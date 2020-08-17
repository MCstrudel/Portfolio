#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "ruternett.c"

int n;		//anntall innleste rutere
struct Ruternett nett;
char trashcan;


void lesInnRutere(char bop[]){
	fprintf(stderr,"leser inn rutere\n");
	FILE * filepointer;
	filepointer = fopen(bop,"rb");
	fread(&n,sizeof(int),1,filepointer);
	nett.str = n;
	fseek(filepointer,1,SEEK_CUR);
	fprintf(stderr,"%d \n",n);
	fprintf(stderr,"%d \n",sizeof(struct Ruter));
	int i;
	for(i=0;i<n;i++){
		fprintf(stderr,"ruter no. %d :",i);
		Ruter *tmp;
		tmp = malloc(sizeof(struct Ruter));
		fread(&(tmp->id),1,1,filepointer); 
		fprintf(stderr,"id %d \n",(int)tmp->id);
		
		fread(&(tmp->flagg),1,1,filepointer);
		fprintf(stderr,"%x \n",tmp->flagg);
		
		fread(&(tmp->lenP),1,1,filepointer); 
		fprintf(stderr,"%d \n",(int)tmp->lenP);
		
		fread(tmp->p,sizeof(char),tmp->lenP,filepointer);
		tmp->p[tmp->lenP]='\0';
		fprintf(stderr,"[%s] \n",tmp->p);
		fprintf(stderr,"\n");
		
		tmp->cCount=0;
		//fread(&trashcan,1,1,filepointer);
		//(stderr,"thrashcan contains %c \n",(char)trashcan);
		
		nett.rutere[i] = tmp; //for loop som initialiserer og allokerer bytes lik størrelsen på tmp
	}	
					  //totalt 257 bytes
	int sig=0;
	while(sig==0){
		char a;
		char b;
			fread(&a,1,1,filepointer);
			fread(&b,1,1,filepointer);
			fread(&trashcan,1,1,filepointer);
		
		if(!feof(filepointer)){
			fprintf(stderr,"%d %d \n",a,b);
			legg_til_kobling(nett.rutere[(int)a],nett.rutere[(int)b]);
			fprintf(stderr,"Kobling fra %d : %d \n",a,nett.rutere[(int)a]->cCount);
		}else{
			sig=1;
		}	
	}

	fclose(filepointer);
	fprintf(stderr,"Alle rutere lest inn\n");
}

void prep(){
	fprintf(stderr,"prep \n");
	int i;
	int j;
	for(i=0;i<256;i++){
		nett.rutere[i]=NULL;
		//for(j=0;j<10;j++){
		//	nett.rutere[i]->connection[j]=NULL;
		//}
	}
}

void skrivUtRutere(char bop[]){
	fprintf(stderr,"Skriver ut rutere\n");
	//skulle legge inn en teller som sørget for at det aldri ble skrevet mer enn 256 linjer, men rakk ikke
	FILE * filepointer;
	filepointer=fopen(bop,"wb");
	const char nl='\n';
	
	fwrite(&(nett.str),sizeof(nett.str),1,filepointer); //n+newline
	fwrite(&nl,sizeof(nl),1,filepointer);
	
	int i;
	for(i=0;i<n;i++){
		if(nett.rutere[i]){
			char * charray = print(nett.rutere[i]);
			fwrite(charray,nett.rutere[i]->lenP+3,1,filepointer);//ruter nett.print()
			free(charray); //frigjør pointeren minnet vi lagde med print();
		}
	}
	int j;
	for(i=0;i<n;i++){
		if(nett.rutere[i]){
			fprintf(stderr,"\n %d %d ",i,nett.rutere[i]->cCount);
			for(j=0;j<nett.rutere[i]->cCount;j++){
				fprintf(stderr,"%d ",j);
				char charray[]={nett.rutere[i]->id,nett.rutere[i]->connection[j]->id};
				fwrite(&charray,sizeof(char),2,filepointer); // i j newline
				fwrite(&nl,sizeof(nl),1,filepointer); //sett ekstern funksjon som teller om ekstra tid
			}
		}else{
			fprintf(stderr,"wha");
		}
	}
	fprintf(stderr,"rutere skrevet til fil \n");
	fclose(filepointer);
}

void kommando(char bop[]){
	fprintf(stderr,"Kommandoer leses inn\n");
	FILE * filepointer;
	char read[257];
	filepointer=fopen(bop,"r");
	int sig=0;
	while(sig==0){
		fgets(read,256,filepointer);
		read[256]='\0';
		fprintf(stderr,"%s",read);
		if(!feof(filepointer)){
			fprintf(stderr,"kommando ");
			if(read[0]=='p'){
				fprintf(stderr,"print ruter no %d: \n", (int)read[6]-48);
				if(nett.rutere[(int)(read[6])-48]){
					char *p=print(nett.rutere[(int)read[6]-48]);
					fprintf(stdout,"Ruter id: %d , Aktiv: %d , traadloes: %d 5ghz: %d , Modell: ",(int)p[0],aktiv(nett.rutere[(int)read[6]-48]),tradlos(nett.rutere[(int)read[6]-48]),fem(nett.rutere[(int)read[6]-48]));
					int i;
					for(i=0;i<(int)p[2];i++){
						fprintf(stdout,"%c",p[i+3]);
					}
					fprintf(stdout,"\n");
					free(p); //frigjør minnet vi satte av med print()
				}else{
					fprintf(stderr,"Ruter finnes ikke\n");
				}
			}
			if(read[0]=='s'){
				if(read[1]=='l'){
					fprintf(stderr,"slett ruter no. %d \n",(int)(read[13])-48);
					slett_ruter(&nett,nett.rutere[(int)(read[13])-48]);
				}else{
					if(read[5]=='m'){
						fprintf(stderr,"sett modell no %d \n",(int)nett.rutere[(int)(read[12])-48]->id);
						settP(nett.rutere[(int)(read[12])-48],read);
						fprintf(stderr,"modell satt til %s \n",nett.rutere[(int)read[12]-48]->p);
					}//sett
					if(read[5]=='f'){
						fprintf(stderr,"sett ruter %d sin flagg bit no. %d til %d \n",(int)read[10]-48,(int)read[12]-48,(int)read[14]-48);
						if(nett.rutere[(int)read[10]-48]){
							if(read[14]=='1'){
								flaggBitHigh(nett.rutere[(int)read[10]-48],(int)read[12]-48);
							}else if(read[14]=='0'){
								flaggBitLow(nett.rutere[(int)read[10]-48],(int)read[12]-48);
							}
						}
					}//sett
				}
			}
			if(read[0]=='f'){
				fprintf(stderr,"sjekk om det finnes rute fra ruter no. %c til ruter no. %c :\n",read[12],read[14]);
				if(finnes_rute(&nett,(int)(read[12])-48,(int)(read[14])-48)){
					fprintf(stdout,"det finnes rute fra ruter no. %c til no. %c \n",read[12],read[14]);
				}else{
					fprintf(stdout,"%ruter-ruten finnes ikke\n");
				}
				cleanvisit(&nett);
			}
			if(read[0]=='l'){
				fprintf(stderr,"legg til kobling fra ruter no. %c til %c \n",read[17],read[19]);
				legg_til_kobling(nett.rutere[(int)(read[17])-48],nett.rutere[(int)(read[19])-48]);
			}
		}else{
			sig=1;
		}
		fprintf(stderr,"\n");
	}
	fclose(filepointer);
}

void freedom(){
	int i;
	for(i=0;i<256;i++){
		if(nett.rutere[i]){
			free(nett.rutere[i]);
		}
	}
}

int main(int argc,char *argv[]){
	prep();
	lesInnRutere(argv[1]);
	kommando(argv[2]);
	skrivUtRutere("out");//setter til argv[1] når jeg har debugget/
	freedom();
	
}
