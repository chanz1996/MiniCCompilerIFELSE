




import re, types, sys, copy

# Exception thrown when invalid token encountered and no default
class LexError(Exception):
    def __init__(self,message,s):
         self.args = (message,)
         self.text = s

# Token class
class LexToken:
    def __str__(self):
        return "LexToken(%s,%r,%d)" % (self.type,self.value,self.lineno)
    def __repr__(self):
        return str(self)
    def skip(self,n):
        try:
            self._skipn += n
        except AttributeError:
            self._skipn = n



class Lexer:
    def __init__(self):
        self.lexre = None           # Master regular expression
        self.lexdata = None         # Actual input data (as a string)
        self.lexpos = 0             # Current position in input text
        self.lexlen = 0             # Length of the input text
        self.lexindexfunc = [ ]     # Reverse mapping of groups to functions and types
        self.lexerrorf = None       # Error rule (if any)
        self.lextokens = None       # List of valid tokens
        self.lexignore = None       # Ignored characters
        self.lineno = 1             # Current line number
        self.debug = 0              # Debugging mode
        self.optimize = 0           # Optimized mode
        self.token = self.errtoken

    def __copy__(self):
        c = Lexer()
        c.lexre = self.lexre
        c.lexdata = self.lexdata
        c.lexpos = self.lexpos
        c.lexlen = self.lexlen
        c.lenindexfunc = self.lexindexfunc
        c.lexerrorf = self.lexerrorf
        c.lextokens = self.lextokens
        c.lexignore = self.lexignore
        c.lineno = self.lineno
        c.optimize = self.optimize
        c.token = c.realtoken

    # ------------------------------------------------------------
    # input() - Push a new string into the lexer
    # ------------------------------------------------------------
    def input(self,s):
        if not isinstance(s,types.StringType):
            raise ValueError, "Expected a string"
        self.lexdata = s
        self.lexpos = 0
        self.lexlen = len(s)
        self.token = self.realtoken
        
        # Change the token routine to point to realtoken()
        global token
        if token == self.errtoken:
            token = self.token

    
    def errtoken(self):
        raise RuntimeError, "No input string given with input()"
    
   
    def realtoken(self):
        # Make local copies of frequently referenced attributes
        lexpos    = self.lexpos
        lexlen    = self.lexlen
        lexignore = self.lexignore
        lexdata   = self.lexdata
        
        while lexpos < lexlen:
            # This code provides some short-circuit code for whitespace, tabs, and other ignored characters
            if lexdata[lexpos] in lexignore:
                lexpos += 1
                continue

            # Look for a regular expression match
            m = self.lexre.match(lexdata,lexpos)
            if m:
                i = m.lastindex
                lexpos = m.end()
                tok = LexToken()
                tok.value = m.group()
                tok.lineno = self.lineno
                tok.lexer = self
                func,tok.type = self.lexindexfunc[i]
                if not func:
                    self.lexpos = lexpos
                    return tok
                
                # If token is processed by a function, call it
                self.lexpos = lexpos
                newtok = func(tok)
                self.lineno = tok.lineno     # Update line number
                
                # Every function must return a token, if nothing, we just move to next token
                if not newtok: continue
                
                # Verify type of the token.  If not in the token map, raise an error
                if not self.optimize:
                    if not self.lextokens.has_key(newtok.type):
                        raise LexError, ("%s:%d: Rule '%s' returned an unknown token type '%s'" % (
                            func.func_code.co_filename, func.func_code.co_firstlineno,
                            func.__name__, newtok.type),lexdata[lexpos:])

                return newtok

            # No match. Call t_error() if defined.
            if self.lexerrorf:
                tok = LexToken()
                tok.value = self.lexdata[lexpos:]
                tok.lineno = self.lineno
                tok.type = "error"
                tok.lexer = self
                oldpos = lexpos
                newtok = self.lexerrorf(tok)
                lexpos += getattr(tok,"_skipn",0)
                if oldpos == lexpos:
                    # Error method didn't change text position at all. This is an error.
                    self.lexpos = lexpos
                    raise LexError, ("Scanning error. Illegal character '%s'" % (lexdata[lexpos]), lexdata[lexpos:])
                if not newtok: continue
                self.lexpos = lexpos
                return newtok

            self.lexpos = lexpos
            raise LexError, ("No match found", lexdata[lexpos:])

        # No more input data
        self.lexpos = lexpos + 1
        return None

        
# -----------------------------------------------------------------------------
# validate_file()
#
# This checks to see if there are duplicated t_rulename() functions or strings
# in the parser input file.  This is done using a simple regular expression
# match on each line in the filename.
# -----------------------------------------------------------------------------

def validate_file(filename):
    import os.path
    base,ext = os.path.splitext(filename)
    if ext != '.py': return 1        # No idea what the file is. Return OK

    try:
        f = open(filename)
        lines = f.readlines()
        f.close()
    except IOError:
        return 1                       # Oh well

    fre = re.compile(r'\s*def\s+(t_[a-zA-Z_0-9]*)\(')
    sre = re.compile(r'\s*(t_[a-zA-Z_0-9]*)\s*=')
    counthash = { }
    linen = 1
    noerror = 1
    for l in lines:
        m = fre.match(l)
        if not m:
            m = sre.match(l)
        if m:
            name = m.group(1)
            prev = counthash.get(name)
            if not prev:
                counthash[name] = linen
            else:
                print "%s:%d: Rule %s redefined. Previously defined on line %d" % (filename,linen,name,prev)
                noerror = 0
        linen += 1
    return noerror

# -----------------------------------------------------------------------------
# _read_lextab(module)
#
# Reads lexer table from a lextab file instead of using introspection.
# -----------------------------------------------------------------------------

def _read_lextab(lexer, fdict, module):
    exec "import %s as lextab" % module
    lexer.lexre = re.compile(lextab._lexre, re.VERBOSE)
    lexer.lexindexfunc = lextab._lextab
    for i in range(len(lextab._lextab)):
        t = lexer.lexindexfunc[i]
        if t:
            if t[0]:
                lexer.lexindexfunc[i] = (fdict[t[0]],t[1])
    lexer.lextokens = lextab._lextokens
    lexer.lexignore = lextab._lexignore
    if lextab._lexerrorf:
        lexer.lexerrorf = fdict[lextab._lexerrorf]
        
# -----------------------------------------------------------------------------
# lex(module)
#
# Build all of the regular expression rules from definitions in the supplied module
# -----------------------------------------------------------------------------
def lex(module=None,debug=0,optimize=0,lextab="lextab"):
    ldict = None
    regex = ""
    error = 0
    files = { }
    lexer = Lexer()
    lexer.debug = debug
    lexer.optimize = optimize
    global token,input
    
    if module:
        # User supplied a module object.
        if isinstance(module, types.ModuleType):
            ldict = module.__dict__
        elif isinstance(module, types.InstanceType):
            _items = [(k,getattr(module,k)) for k in dir(module)]
            ldict = { }
            for (i,v) in _items:
                ldict[i] = v
        else:
            raise ValueError,"Expected a module or instance"
        
    else:
        # No module given.  We might be able to get information from the caller.
        try:
            raise RuntimeError
        except RuntimeError:
            e,b,t = sys.exc_info()
            f = t.tb_frame
            f = f.f_back           # Walk out to our calling function
            ldict = f.f_globals    # Grab its globals dictionary

    if optimize and lextab:
        try:
            _read_lextab(lexer,ldict, lextab)
            if not lexer.lexignore: lexer.lexignore = ""            
            token = lexer.token
            input = lexer.input
            return lexer
        
        except ImportError:
            pass
        
    # Get the tokens map
    if (module and isinstance(module,types.InstanceType)):
        tokens = getattr(module,"tokens",None)
    else:
        try:
            tokens = ldict["tokens"]
        except KeyError:
            tokens = None
        
    if not tokens:
        raise SyntaxError,"lex: module does not define 'tokens'"
    if not (isinstance(tokens,types.ListType) or isinstance(tokens,types.TupleType)):
        raise SyntaxError,"lex: tokens must be a list or tuple."

    # Build a dictionary of valid token names
    lexer.lextokens = { }
    if not optimize:

        # Utility function for verifying tokens
        def is_identifier(s):
            for c in s:
                if not (c.isalnum() or c == '_'): return 0
            return 1
        
        for n in tokens:
            if not is_identifier(n):
                print "lex: Bad token name '%s'" % n
                error = 1
            if lexer.lextokens.has_key(n):
                print "lex: Warning. Token '%s' multiply defined." % n
            lexer.lextokens[n] = None
    else:
        for n in tokens: lexer.lextokens[n] = None
        

    if debug:
        print "lex: tokens = '%s'" % lexer.lextokens.keys()

    # Get a list of symbols with the t_ prefix
    tsymbols = [f for f in ldict.keys() if f[:2] == 't_']
    
    # Now build up a list of functions and a list of strings
    fsymbols = [ ]
    ssymbols = [ ]
    for f in tsymbols:
        if callable(ldict[f]):
            fsymbols.append(ldict[f])
        elif isinstance(ldict[f], types.StringType):
            ssymbols.append((f,ldict[f]))
        else:
            print "lex: %s not defined as a function or string" % f
            error = 1
            
    # Sort the functions by line number
    fsymbols.sort(lambda x,y: cmp(x.func_code.co_firstlineno,y.func_code.co_firstlineno))

    # Sort the strings by regular expression length
    ssymbols.sort(lambda x,y: (len(x[1]) < len(y[1])) - (len(x[1]) > len(y[1])))
    
    # Check for non-empty symbols
    if len(fsymbols) == 0 and len(ssymbols) == 0:
        raise SyntaxError,"lex: no rules of the form t_rulename are defined."

    # Add all of the rules defined with actions first
    for f in fsymbols:
        
        line = f.func_code.co_firstlineno
        file = f.func_code.co_filename
        files[file] = None

        ismethod = isinstance(f, types.MethodType)

        if not optimize:
            nargs = f.func_code.co_argcount
            if ismethod:
                reqargs = 2
            else:
                reqargs = 1
            if nargs > reqargs:
                print "%s:%d: Rule '%s' has too many arguments." % (file,line,f.__name__)
                error = 1
                continue

            if nargs < reqargs:
                print "%s:%d: Rule '%s' requires an argument." % (file,line,f.__name__)
                error = 1
                continue

            if f.__name__ == 't_ignore':
                print "%s:%d: Rule '%s' must be defined as a string." % (file,line,f.__name__)
                error = 1
                continue
        
        if f.__name__ == 't_error':
            lexer.lexerrorf = f
            continue

        if f.__doc__:
            if not optimize:
                try:
                    c = re.compile(f.__doc__, re.VERBOSE)
                except re.error,e:
                    print "%s:%d: Invalid regular expression for rule '%s'. %s" % (file,line,f.__name__,e)
                    error = 1
                    continue

                if debug:
                    print "lex: Adding rule %s -> '%s'" % (f.__name__,f.__doc__)

            # Okay. The regular expression seemed okay.  Let's append it to the master regular
            # expression we're building
  
            if (regex): regex += "|"
            regex += "(?P<%s>%s)" % (f.__name__,f.__doc__)
        else:
            print "%s:%d: No regular expression defined for rule '%s'" % (file,line,f.__name__)

    # Now add all of the simple rules
    for name,r in ssymbols:

        if name == 't_ignore':
            lexer.lexignore = r
            continue
        
        if not optimize:
            if name == 't_error':
                raise SyntaxError,"lex: Rule 't_error' must be defined as a function"
                error = 1
                continue
        
            if not lexer.lextokens.has_key(name[2:]):
                print "lex: Rule '%s' defined for an unspecified token %s." % (name,name[2:])
                error = 1
                continue
            try:
                c = re.compile(r,re.VERBOSE)
            except re.error,e:
                print "lex: Invalid regular expression for rule '%s'. %s" % (name,e)
                error = 1
                continue
            if debug:
                print "lex: Adding rule %s -> '%s'" % (name,r)
                
        if regex: regex += "|"
        regex += "(?P<%s>%s)" % (name,r)

    if not optimize:
        for f in files.keys():
            if not validate_file(f):
                error = 1
    try:
        if debug:
            print "lex: regex = '%s'" % regex
        lexer.lexre = re.compile(regex, re.VERBOSE)

        # Build the index to function map for the matching engine
        lexer.lexindexfunc = [ None ] * (max(lexer.lexre.groupindex.values())+1)
        for f,i in lexer.lexre.groupindex.items():
            handle = ldict[f]
            if type(handle) in (types.FunctionType, types.MethodType):
                lexer.lexindexfunc[i] = (handle,handle.__name__[2:])
            else:
                # If rule was specified as a string, we build an anonymous
                # callback function to carry out the action
                lexer.lexindexfunc[i] = (None,f[2:])

        # If a lextab was specified, we create a file containing the precomputed
        # regular expression and index table
        
        if lextab and optimize:
            lt = open(lextab+".py","w")
            lt.write("# %s.py.  This file automatically created by PLY. Don't edit.\n" % lextab)
            lt.write("_lexre = %s\n" % repr(regex))
            lt.write("_lextab = [\n");
            for i in range(0,len(lexer.lexindexfunc)):
                t = lexer.lexindexfunc[i]
                if t:
                    if t[0]:
                        lt.write("  ('%s',%s),\n"% (t[0].__name__, repr(t[1])))
                    else:
                        lt.write("  (None,%s),\n" % repr(t[1]))
                else:
                    lt.write("  None,\n")
                    
            lt.write("]\n");
            lt.write("_lextokens = %s\n" % repr(lexer.lextokens))
            lt.write("_lexignore = %s\n" % repr(lexer.lexignore))
            if (lexer.lexerrorf):
                lt.write("_lexerrorf = %s\n" % repr(lexer.lexerrorf.__name__))
            else:
                lt.write("_lexerrorf = None\n")
            lt.close()
        
    except re.error,e:
        print "lex: Fatal error. Unable to compile regular expression rules. %s" % e
        error = 1
    if error:
        raise SyntaxError,"lex: Unable to build lexer."
    if not lexer.lexerrorf:
        print "lex: Warning. no t_error rule is defined."

    if not lexer.lexignore: lexer.lexignore = ""
    
    # Create global versions of the token() and input() functions
    token = lexer.token
    input = lexer.input
    
    return lexer

# -----------------------------------------------------------------------------
# run()
#
# This runs the lexer as a main program
# -----------------------------------------------------------------------------

def runmain(lexer=None,data=None):
    if not data:
        try:
            filename = sys.argv[1]
            f = open(filename)
            data = f.read()
            f.close()
        except IndexError:
            print "Reading from standard input (type EOF to end):"
            data = sys.stdin.read()

    if lexer:
        _input = lexer.input
    else:
        _input = input
    _input(data)
    if lexer:
        _token = lexer.token
    else:
        _token = token
        
    while 1:
        tok = _token()
        if not tok: break
        print "(%s,'%s',%d)" % (tok.type, tok.value, tok.lineno)
        
    


