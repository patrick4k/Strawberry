grammar strawberry;

script: statment* EOF;

statment
: bodyFunction #bodyFuncStat
| expression? '!' #returnStat
| expression ENDL #exprStat
;

arg
: expression #exprArg
| '...' identifier #expandIdentifier
| expression '..' expression #rangeArray
| expression '..' expression ':' expression #linespaceArray
| expression '..' expression '::' expression #linespaceCountArray
;

args
: (arg (',' arg)*)?
;

block: '{' statment* '}';

body
: block #blockBody
| expression ENDL #exprBody
;

declaration
: 'let' identifier '=' expression #declar
| 'let' identifier '->' identifier #declarPoint
;

/* ASSIGNMENT */
assignment
: identifier '=' expression #assign

// Op assign
| identifier '+=' expression #addAssign
| identifier '-=' expression #subAssign
| identifier '*=' expression #multAssign
| identifier '/=' expression #divAssign
| identifier '^=' expression #divAssign

// Point
| identifier '->' identifier #assignPoint
;

/* EXPRESSION */
expression
// Tertary operations
: expression '?' expression (':' expression)? #ifExpr

| '(' args ') -> {' statment* '}' #lambda

// Set var
| declaration #declarExpr
| assignment #assignExpr

// Prefix expressions
| '-' expression #negExpr
| '\\' identifier #idRefExpr

// Suffix expressions
| identifier '++' #incremExpr
| identifier '--' #decremExpr

// Operator expressions
| expression '^' expression #powExpr
| expression op=('*'|'/') expression #multDivExpr
| expression op=('+'|'-') expression #addSubExpr

// Comparitive operations
| expression op=(
'>' | '>=' | '<=' | '<' | '==' | '!='
) expression
#exprCmpExpr

// Boolean operations
| expression op=(
'||' | '!|' | '&&' | '!&'
) expression
#boolCmpExpr

// Enclosed expressions
| '|' expression '|' #absExpr
| '(' expression ')' #parExpr
| arrayLiteral #arrayExpr

// Literal expressions
| word=('true' | 'false' | 'null') #keywordLit
| identifier #identifierExpr
| NUMBER #numberExpr
| STRING #stringExpr
;

arrayLiteral
: '[' args ']' #argsArray // either string or index lookup
;

identifier
: (ID '(' args ')' body)+ #bodyFunCall
| identifier '(' args ')' #funCall
| identifier ('.' ID)+ #objAccess
| identifier arrayLiteral #arrayExprAccess
| ID #idAccess
| '_' #defaultId
;

bodyFunction: (ID '(' args ')' body)+ ;

ID: WORD (WORD | DIGIT)*;

NUMBER: DIGIT+ ('.' DIGIT+)?;
STRING: '"' .*? '"';

DIGIT: [0-9];
WORD: (UCLETTER | LCLETTER)+;
fragment UCLETTER: [A-Z];
fragment LCLETTER: [a-z];

ENDL
: ';'
;

fragment NL: ('\r' | '\n')+;

IGNORE
: COMMENT -> skip
;

fragment COMMENT
:'//' ~('\r' | '\n')*
|'/*' .*? '*/'
;

WS
: [ \t\r\n] + -> skip
;
