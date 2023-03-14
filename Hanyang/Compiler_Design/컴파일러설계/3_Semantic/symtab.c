/****************************************************/
/* File: symtab.c                                   */
/* Symbol table implementation for the TINY compiler*/
/* (allows only one symbol table)                   */
/* Symbol table is implemented as a chained         */
/* hash table                                       */
/* Compiler Construction: Principles and Practice   */
/* Kenneth C. Louden                                */
/****************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symtab.h"
#include "globals.h"

/* SHIFT is the power of two used as multiplier
   in hash function  */
#define SHIFT 4
#define MAX_SCOPES 1000

/* the hash function */
static int hash ( char * key )
{ int temp = 0;
  int i = 0;
  while (key[i] != '\0')
  { temp = ((temp << SHIFT) + key[i]) % SIZE;
    ++i;
  }
  return temp;
}

ScopeList scopes[MAX_SCOPES], scopeStack[MAX_SCOPES];
int cntScope = 0, cntScopeStack = 0, location[MAX_SCOPES];

/* Procedure st_insert inserts line numbers and
 * memory locations into the symbol table
 * loc = memory location is inserted only the
 * first time, otherwise ignored
 */
//void st_insert( char * scope, char * name, ExpType type, int lineno, int loc )
void st_insert( char * name, int lineno, int loc, TreeNode * treeNode )
{ int h = hash(name);
  ScopeList nowScope = sc_top();
  BucketList l =  nowScope->hashTable[h];
  while ((l != NULL) && (strcmp(name,l->name) != 0))
    l = l->next;
  if (l == NULL) /* variable not yet in table */
  { 
    //printf("variable not in table %d\n",loc);
    l = (BucketList) malloc(sizeof(struct BucketListRec));
    l->name = name;
    l->treeNode = treeNode;
    l->lines = (LineList) malloc(sizeof(struct LineListRec));
    l->lines->lineno = lineno;
    l->memloc = loc;
    l->lines->next = NULL;
    l->next = nowScope->hashTable[h];
    nowScope->hashTable[h] = l; 
  }
  else /* found in table, so just add line number */
  { 
    // LineList t = l->lines;
    // while (t->next != NULL) t = t->next;
    // t->next = (LineList) malloc(sizeof(struct LineListRec));
    // t->next->lineno = lineno;
    // t->next->next = NULL;
  }
} /* st_insert */

/* Function st_lookup returns the memory 
 * location of a variable or -1 if not found
 */
int st_lookup ( char * name )
{ BucketList l = get_bucket(name);
  if(l != NULL) return l->memloc;
  return -1;
}

void st_add_lineno( char * name, int lineno )
{ BucketList bl = get_bucket(name);
  LineList ll = bl->lines;
  while(ll->next != NULL)
    ll = ll->next;
  ll->next = (LineList) malloc(sizeof(struct LineListRec));
  ll->next->lineno = lineno;
  ll->next->next = NULL;
}

int st_lookup_top ( char * name )
{ int h = hash(name);
  ScopeList nowScope = sc_top();
  //while(nowScope != NULL)
   BucketList l = nowScope->hashTable[h];
    while((l != NULL) && (strcmp(name,l->name) != 0))
      l = l->next;
    if(l != NULL)
      return l->memloc;
  //  nowScope = nowScope->parent;
  
  return -1;
}

BucketList get_bucket ( char * name )
{ int h = hash(name);
  ScopeList nowScope = sc_top();
  while(nowScope != NULL)
  { BucketList l = nowScope->hashTable[h];
    while((l != NULL) && (strcmp(name,l->name) != 0) )
      l = l->next;
    if(l != NULL)
      return l;
    nowScope = nowScope->parent;
  }
  return NULL;
}

/* Stack for static scope */
ScopeList sc_create ( char * funcName )
{ ScopeList newScope;
  newScope = (ScopeList) malloc(sizeof(struct ScopeListRec));
  newScope->funcName = funcName;
  newScope->nestedLevel = cntScopeStack;
  newScope->parent = sc_top();
  scopes[cntScope++] = newScope;

  return newScope;
}

ScopeList sc_top( void )
{ if(!cntScopeStack)
    return NULL;
  return scopeStack[cntScopeStack - 1];
}

void sc_pop ( void )
{ if(cntScopeStack)
    cntScopeStack--;
}

void sc_push ( ScopeList scope )
{ scopeStack[cntScopeStack] = scope;
  location[cntScopeStack++] = 0;
}

int addLocation ( void )
{ return location[cntScopeStack - 1]++;
}

/* Procedure printSymTab prints a formatted 
 * listing of the symbol table contents 
 * to the listing file
 */

void printSymTab(FILE * listing)
{ print_SymTab(listing);
  fprintf(listing,"\n");
  print_FuncTab(listing);
  fprintf(listing,"\n");
  print_Func_globVar(listing);
  fprintf(listing,"\n");
  print_FuncP_N_LoclVar(listing);
} /* printSymTab */

void print_SymTab(FILE * listing)
{ int i, j;
  fprintf(listing,"< Symbol Table >\n");
  fprintf(listing,"Symbol Name   Symbol Kind   Symbol Type    Scope Name   Location  Line Numbers\n");
  fprintf(listing,"-------------  -----------  -------------  ------------  --------  ------------\n");

  for (i = 0; i < cntScope; i++)
  { ScopeList nowScope = scopes[i];
    BucketList * hashTable = nowScope->hashTable;

    for (j = 0; j < SIZE; j++)
    { if(hashTable[j] != NULL)
      { BucketList bl = hashTable[j];
        TreeNode * node = bl->treeNode;

        while(bl != NULL)
        { LineList ll = bl->lines;
          fprintf(listing,"%-15s",bl->name);
          switch (node->nodekind)

          { case DeclareK:
              switch (node->kind.decl)
              { case FunctionK:
                  fprintf(listing,"%-15s","Function");
                  if(node->type == 1) fprintf(listing,"%-15s","int");
                  else if(node->type == 0) fprintf(listing,"%-15s","void");
                  break;
                case VariableK:
                  switch (node->type)
                  { case Void:
                      fprintf(listing,"%-15s","void");
                      break;
                    case Integer:
                      fprintf(listing,"%-15s","Variable");
                      if(node->type == 1) fprintf(listing,"%-15s","int");
                      break;
                    default:
                      break;
                  }
                  break;
                case ArrayVariableK:
                  fprintf(listing,"%-15s","Variable");
                  if(node->type == 2) fprintf(listing,"%-15s","int[]");
                  break;
                default:
                  break;
              }
              break;
            case ParameterK:
              switch (node->kind.param)
              { case ArrayParameterK:
                  fprintf(listing,"%-15s","Variable");
                  if(node->type == 2) fprintf(listing,"%-15s","int[]");
                  break;
                case NonArrayParameterK:
                  fprintf(listing,"%-15s","Variable");
                  if(node->type == 1) fprintf(listing,"%-15s","int");
                  break;
                default:
                  break;
              }
              break;
            default:
              break;
          }

          fprintf(listing,"%-12s",nowScope->funcName);
          fprintf(listing,"%-10d",bl->memloc);
          while(ll != NULL)
          { fprintf(listing,"%4d",ll->lineno);
            ll = ll->next;
          }
          fprintf(listing,"\n");
          
          bl = bl->next;
        }
      }
    }
  }
}

void print_FuncTab(FILE * listing)
{ int i, j, k, l;
  fprintf(listing,"< Functions >\n");
  fprintf(listing,"Function Name   Return Type   Parameter Name  Parameter Type\n");
  fprintf(listing,"-------------  -------------  --------------  --------------\n");

  for (i = 0; i < cntScope; i++)
  { ScopeList nowScope = scopes[i];
    BucketList * hashTable = nowScope->hashTable;

    for (j = 0; j < SIZE; j++)
    { if(hashTable[j] != NULL)
      { BucketList bl = hashTable[j];
        TreeNode * node = bl->treeNode;

        while(bl != NULL)
        { switch (node->nodekind)
          { case DeclareK:
              if(node->kind.decl == FunctionK)  /* Function print */
              { fprintf(listing,"%-15s",bl->name);
                switch (node->type)
                { case Void:
                    fprintf(listing,"%-16s","void");
                    break;
                  case Integer:
                    fprintf(listing,"%-16s","int");
                    break;
                  default:
                    break;
                }

                int noParam = TRUE;
                for (k = 0; k < cntScope; k++)
                { ScopeList paramScope = scopes[k];
                  if (strcmp(paramScope->funcName, bl->name) != 0)
                    continue;
                  BucketList * paramhashTable = paramScope->hashTable;                  //printf("c\n");

                  for (l = 0; l < SIZE; l++)
                  { if(paramhashTable[l] != NULL)
                    { BucketList pbl = paramhashTable[l];
                      TreeNode * pnode = pbl->treeNode;

                      while(pbl != NULL)
                      { switch (pnode->nodekind)
                        { case ParameterK:
                            noParam = FALSE;
                            fprintf(listing,"\n");
                            fprintf(listing,"%-40s","");
                            fprintf(listing,"%-16s",pbl->name);
                            switch (pnode->type)
                            { case Integer:
                                fprintf(listing,"%-17s","int");
                                break;
                              case IntegerArray:
                                fprintf(listing,"%-14s","int[]");
                                break;
                              default:
                                break;
                            }
                            break;
                          default:
                            break;
                        }
                        pbl = pbl->next;
                      }
                    }
                  }
                  break;
                }
                if (noParam)
                { fprintf(listing,"%-16s","");
                  if (strcmp(bl->name, "output") != 0)
                    fprintf(listing,"%-19s","void");
                  else 
                    fprintf(listing,"\n%-47s%-1s","","int");
                }

                fprintf(listing,"\n");
              }
              break;
            default:
              break;
          }          
          bl = bl->next;
        }
      }
    }
  }
}

void print_Func_globVar(FILE * listing)
{ int i, j;
  fprintf(listing,"< Global Symbols >\n");
  fprintf(listing," Symbol Name   Symbol Kind   Symbol Type\n");
  fprintf(listing,"-------------  -----------  -------------\n");

  for (i = 0; i < cntScope; i++)
  { ScopeList nowScope = scopes[i];
    if (strcmp(nowScope->funcName, "global") != 0)
      continue;

    BucketList * hashTable = nowScope->hashTable;

    for (j = 0; j < SIZE; j++)
    { if(hashTable[j] != NULL)
      { BucketList bl = hashTable[j];
        TreeNode * node = bl->treeNode;

        while(bl != NULL)
        { switch (node->nodekind)
          { case DeclareK:
              fprintf(listing,"%-15s",bl->name);
              switch (node->kind.decl)
              { case FunctionK:
                  fprintf(listing,"%-11s","Function");
                  switch (node->type)
                  { case Void:
                      fprintf(listing,"%-20s","    void");
                      break;
                    case Integer:
                      fprintf(listing,"%-20s","    int");
                      break;
                    default:
                      break;
                  }
                  break;
                case VariableK:
                  switch (node->type)
                  { case Void:
                      fprintf(listing,"%-11s","Variable");
                      fprintf(listing,"%-20s","    void");
                      break;
                    case Integer:
                      fprintf(listing,"%-11s","Variable");
                      fprintf(listing,"%-20s","    int");
                      break;
                    default:
                      break;
                  }
                  break;
                case ArrayVariableK:
                  fprintf(listing,"%-11s","Variable");
                  fprintf(listing,"%-20s","    int[]");
                  break;
                default:
                  break;
              }
              fprintf(listing,"\n");
              break;              
            default:
              break;
          }
          bl = bl->next;
        }
      }
    }
    break;
  }
}

void print_FuncP_N_LoclVar(FILE * listing)
{ int i, j;
  fprintf(listing,"< Scopes >\n");
  fprintf(listing," Scope Name   Nested Level   Symbol Name   Symbol Type\n");
  fprintf(listing,"------------  ------------  -------------  -----------\n");

  for (i = 0; i < cntScope; i++)
  { ScopeList nowScope = scopes[i];
    if (strcmp(nowScope->funcName, "global") == 0)
      continue;
    BucketList * hashTable = nowScope->hashTable;
    //fprintf(listing,"%s\n",nowScope->funcName); 

    int noParamVar = TRUE;
    for (j = 0; j < SIZE; j++)
    { if(hashTable[j] != NULL)
      { BucketList bl = hashTable[j];
        TreeNode * node = bl->treeNode;

        while(bl != NULL)
        { switch (node->nodekind)
          { case DeclareK:
              noParamVar = FALSE;
              fprintf(listing,"%-16s",nowScope->funcName);
              fprintf(listing,"%-14d",nowScope->nestedLevel);
              switch (node->kind.decl)
              { case VariableK:
                  switch (node->type)
                  { case Void:
                      fprintf(listing,"%-15s",node->attr.name);
                      fprintf(listing,"%-11s","void");
                      break;
                    case Integer:
                      fprintf(listing,"%-15s",node->attr.name);
                      fprintf(listing,"%-11s","int");
                      break;
                    default:
                      break;
                  }
                  break;
                case ArrayVariableK:
                  fprintf(listing,"%-15s",node->attr.arr.name);
                  fprintf(listing,"%-11s","int[]");
                  break;
                default:
                  break;
              }
              fprintf(listing,"\n");
              break;              
            case ParameterK:
              noParamVar = FALSE;
              fprintf(listing,"%-16s",nowScope->funcName);
              fprintf(listing,"%-14d",nowScope->nestedLevel);
              switch (node->kind.param)
              { case ArrayParameterK:
                  fprintf(listing,"%-15s",node->attr.name);
                  fprintf(listing,"%-11s","int[]");
                  break;
                case NonArrayParameterK:
                  fprintf(listing,"%-15s",node->attr.name);
                  fprintf(listing,"%-11s","int");
                  break;
                default:
                  break;
              }
              fprintf(listing,"\n");
              break;
            default:
              break;
          }
          bl = bl->next;
        }
      }
    }
    if (!noParamVar)
      fprintf(listing,"\n");
  }
}