%{
#include <stdio.h>
#include <stdlib.h> // Include for exit function and malloc
#include <string.h>

int line_number = 1;
int string_error = 0;

// Define a struct for tokens
typedef struct Token {
    char lexeme[1000];
    char token_type[20];
    int count;
    struct Token* next;
} Token;

Token* head = NULL;

void report_error(const char* message) {
    fprintf(stderr, "Error at line %d: %s\n", line_number, message);
    // Exit after reporting the first error
    exit(1);
}

// Function to add tokens to the linked list
void add_token(const char* lexeme, const char* token_type) {
    Token* current = head;
    while (current != NULL) {
        if (strcmp(current->lexeme, lexeme) == 0 && strcmp(current->token_type, token_type) == 0) {
            current->count++;
            return;
        }
        current = current->next;
    }
    Token* new_token = (Token*)malloc(sizeof(Token));
    strcpy(new_token->lexeme, lexeme);
    strcpy(new_token->token_type, token_type);
    new_token->count = 1;
    new_token->next = head;
    head = new_token;
    // Debugging statement to confirm token addition
}

// Function to compare tokens for sorting
int compare_tokens(const void* a, const void* b) {
    Token* tokenA = *(Token**)a;
    Token* tokenB = *(Token**)b;
    return strcmp(tokenA->lexeme, tokenB->lexeme);
}

// Function to print all tokens
void print_tokens() {

    // Count tokens
    int token_count = 0;
    Token* current = head;
    while (current != NULL) {
        token_count++;
        current = current->next;
    }

    // Create an array of tokens for sorting
    Token** token_array = (Token**)malloc(token_count * sizeof(Token*));
    current = head;
    for (int i = 0; i < token_count; i++) {
        token_array[i] = current;
        current = current->next;
    }

    // Sort the tokens
    qsort(token_array, token_count, sizeof(Token*), compare_tokens);

    // Print sorted tokens
    for (int i = 0; i < token_count; i++) {
        printf("%-15s %d        %-20s\n", token_array[i]->token_type, token_array[i]->count, token_array[i]->lexeme);
    }

    // Free allocated memory
    free(token_array);
    current = head;
    while (current != NULL) {
        Token* temp = current;
        current = current->next;
        free(temp);
    }

}
%}

%option noyywrap

%%

\"[^\"]*\" {
    add_token(yytext, "STRING");
}

[A-Za-z][A-Za-z0-9]* {
    if (strcasecmp(yytext, "ARRAY") == 0) {
        add_token(yytext, "KEYWORD");
    } else if (strcasecmp(yytext, "BEGIN") == 0) {
        add_token(yytext, "KEYWORD");
    } else if (strcasecmp(yytext, "BOOLEAN") == 0) {
        add_token(yytext, "KEYWORD");
    } else if (strcasecmp(yytext, "COMMENT") == 0) {
        add_token(yytext, "KEYWORD");
    } else if (strcasecmp(yytext, "CONTINUE") == 0) {
        add_token(yytext, "KEYWORD");
    } else if (strcasecmp(yytext, "DO") == 0) {
        add_token(yytext, "KEYWORD");
    } else if (strcasecmp(yytext, "DOUBLE") == 0) {
        add_token(yytext, "KEYWORD");
    } else if (strcasecmp(yytext, "ELSE") == 0) {
        add_token(yytext, "KEYWORD");
    } else if (strcasecmp(yytext, "END") == 0) {
        add_token(yytext, "KEYWORD");
    } else if (strcasecmp(yytext, "FALSE") == 0) {
        add_token(yytext, "KEYWORD");
    } else if (strcasecmp(yytext, "FOR") == 0) {
        add_token(yytext, "KEYWORD");
    } else if (strcasecmp(yytext, "IF") == 0) {
        add_token(yytext, "KEYWORD");
    } else if (strcasecmp(yytext, "INTEGER") == 0) {
        add_token(yytext, "KEYWORD");
    } else if (strcasecmp(yytext, "LABEL") == 0) {
        add_token(yytext, "KEYWORD");
    } else if (strcasecmp(yytext, "LIST") == 0) {
        add_token(yytext, "KEYWORD");
    } else if (strcasecmp(yytext, "LONG") == 0) {
        add_token(yytext, "KEYWORD");
    } else if (strcasecmp(yytext, "OWN") == 0) {
        add_token(yytext, "KEYWORD");
    } else if (strcasecmp(yytext, "PROCEDURE") == 0) {
        add_token(yytext, "KEYWORD");
    } else if (strcasecmp(yytext, "STEP") == 0) {
        add_token(yytext, "KEYWORD");
    } else if (strcasecmp(yytext, "SWITCH") == 0) {
        add_token(yytext, "KEYWORD");
    } else if (strcasecmp(yytext, "THEN") == 0) {
        add_token(yytext, "KEYWORD");
    } else if (strcasecmp(yytext, "TRUE") == 0) {
        add_token(yytext, "KEYWORD");
    } else if (strcasecmp(yytext, "UNTIL") == 0) {
        add_token(yytext, "KEYWORD");
    } else if (strcasecmp(yytext, "VALUE") == 0) {
        add_token(yytext, "KEYWORD");
    } else if (strcasecmp(yytext, "WHILE") == 0) {
        add_token(yytext, "KEYWORD");
    } else {
        add_token(yytext, "IDENTIFIER");
    }
}

[0-9]+\.[0-9]+ {
    add_token(yytext, "FLOATING_POINT");
}

0[xX][0-9A-Fa-f]+ {
    add_token(yytext, "HEXADECIMAL");
}

[0-9]+ {
    add_token(yytext, "INTEGER");
}

[:;,\(\)\{\}\[\]] {
    add_token(yytext, "DELIMITER");
}

[\+\-\*/%\^&«»<>=!] {
    if (strlen(yytext) > 1) {
        report_error("Invalid operator");
    } else {
        add_token(yytext, "OPERATOR");
    }
}

[ \t\r]+ {
    // skip whitespace
}

\n {
    line_number++;
}

. {
    report_error("Invalid character");
}
%%

int main(int argc, char* argv[]) {
        const char* filename = "public2.knp";
        FILE *file = fopen(filename, "r");
        if (!file) {
            fprintf(stderr, "Error: could not open file %s\n", argv[1]);
            return 1;
        }
        yyin = file;
    

    while (yylex() != 0) {
        // Continue processing input until EOF
    }
    
    
        fclose(yyin); // close the file if it was opened
    

    print_tokens(); // Print all tokens after scanning

    return 0;
}
