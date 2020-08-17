#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

struct Ruternett{
	int str;                         //size
	struct Ruter* rutere[256];      //(int) char router pointers 
	//char admatrix[256][256];         //adjacency matrix [kobling fra][kobling til]
};

typedef struct Ruternett Ruternett;

struct Ruter{         
	char id;
	char flagg;
	char lenP;
	char p[254];
	struct Ruter * connection[10];
	char cCount;
};

typedef struct Ruter Ruter;

void settP(struct Ruter * r,char bop[]){//setter produsent char array 
										//parametere: Ruter pointer til ruter som skal endres, char array med nytt navn
	fprintf(stderr,"%d %d",strlen(bop),r->id);
	
	r->lenP=(char)(strlen(bop)-14);
	fprintf(stderr,"%d",r->lenP);
	strncpy(r->p,bop+13,r->lenP-1);
}

int aktiv(struct Ruter *r){ //Henter aktiv bit flagg i ruteren r pekes til
	return r->flagg & 1;
}

int tradlos(struct Ruter *r){//Henter trådløs bit flagg i ruteren r pekes til
	return (r->flagg>>1) & 1;
}

int fem(struct Ruter *r){//Henter 5ghz bit flagg i ruteren r pekes til
	return (r->flagg>>2) & 1;
}

bool visited(struct Ruter *r){//Henter besøk bit flagg i ruteren r pekes til(brukes til graftraversering)
	return (r->flagg>>3) & 1;
}

void visit(struct Ruter *r){//setter besøk bit i flagg til ruteren r peker på til 1
	r->flagg |= 1UL << 3;
}

void unvisit(struct Ruter *r){//setter besøk bit i flagg til ruteren r peker på til 0
	r->flagg &= ~(1UL << 3);
}

void flaggBitHigh(struct Ruter *r,int a){
	r->flagg |= 1UL << a;
}

void flaggBitLow(struct Ruter *r,int a){
	r->flagg &= ~(1UL << a);
}

bool finnes_rute(struct Ruternett *rn,int a,int b) {
	bool check=false;
	int i;
	for(i=0;i<256;i++){
		if(rn->rutere[i]&&!check){
			int j;
			for(j=0;j<rn->rutere[i]->cCount;j++){
				if(rn->rutere[i]->connection[j]==rn->rutere[b]){
					fprintf(stderr,"rute funnet \n");
					check=true;
					break;
				}else if(visited(rn->rutere[i])){
				}else{
					visit(rn->rutere[i]);
					check=finnes_rute(rn,i,b);
					if(check){
						break;
					}
				}
			}
		}
	}
	return check;
}

void cleanvisit(struct Ruternett *rn){
	fprintf(stderr,"cleaning... \n");
	int i;
	for(i=0;i<256;i++){
		if(rn->rutere[i]){
			unvisit(rn->rutere[i]);
		}
	}
}

char * print(struct Ruter *r){   //ruter til char array
	char * charray=malloc((4+(r->lenP))*sizeof(char));
	charray[0]=r->id;
	charray[1]=r->flagg;
	charray[2]=r->lenP;
	int i;
	for(i=0;i<(r->lenP);i++){
		charray[i+3]=r->p[i];
	}
	charray[3+(r->lenP)]='\0'; //reserverer og fyller lengden på produsent +4 bytes 
	return charray;
}


void legg_til_kobling(struct Ruter *a,struct Ruter * b){
		a->connection[a->cCount]=b;
		a->cCount++;
}

struct Ruter* slett_ruter(struct Ruternett * rn,struct Ruter *r){
	int i;
	for(i=0;i<256;i++){
		if(rn->rutere[i]){
			int j;
			for(j=0;j<rn->rutere[i]->cCount;j++){
				if(rn->rutere[i]->connection[j]==r){
					rn->rutere[i]->connection[j]=NULL;
					if(!(rn->rutere[i]->cCount==j+1)){
						fprintf(stderr,"hoi %d %d ",i,j);
						rn->rutere[i]->connection[j]=rn->rutere[i]->connection[(rn->rutere[i]->cCount)-1];
						rn->rutere[i]->connection[(rn->rutere[i]->cCount)-1]=NULL;
					}
					rn->rutere[i]->cCount--;
				}
			}
			for(j=0;j<rn->rutere[i]->cCount;j++){
					fprintf(stderr,"%d ",rn->rutere[i]->connection[j]->id);
			}
			
		}
	}
	if(rn->rutere[(int)r->id]){
		rn->rutere[(int)r->id]=NULL;
		free(r);
		rn->str--;
	}
}


