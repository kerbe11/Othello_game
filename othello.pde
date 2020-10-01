class IndexJeu
{
  int i,j,gain;
  IndexJeu(int pi, int pj, int pgain)
  {
    i=pi;j=pj;gain=pgain;
  }
}

int he,wi; //pour récupérer la hauteur et la largeur

//La matrice heuristique onfère une certaine priorité à cetains points du jeu comme par exemple les corners
int[][] heuristique = {{120,-20,20,5,5,20,-20,120},
                       {-20,-40,-5,-5,-5,-5,-40,-20},
                       {20,-5,15,3,3,15,-5,20},
                       {5,-5,3,3,3,3,-5,5},
                       {5,-5,3,3,3,3,-5,5},
                       {20,-5,15,3,3,15,-5,20},
                       {-20,-40,-5,-5,-5,-5,-40,-20},
                       {120,-20,20,5,5,20,-20,120}};
int[][] othello = new int[8][8];
int i,j,stepx,stepy,joueur1=1,joueur2=0,rouge=0,vert=0,typeJeu;
int profondeur;//pour déterminer la profondeur de descente dans l'arbre

void setup()
{
  size(1000,800);
  he=height;
  wi=800;
  background(255);
  //initialiser la matrice de jeu
  initialise(othello);
  
  //calcul des pas
  stepx=wi/othello.length;
  stepy=he/othello.length;
  
  //pour l'interface graphique
  initialiseGUI();
  
}

void mousePressed()
{
  
  if((mouseX>=830 && mouseX<=970) && (mouseY>=90 && mouseY<=140))
    typeJeu=1;
  else if((mouseX>=830 && mouseX<=970) && (mouseY>=170 && mouseY<=220))
    typeJeu=21;
  else if((mouseX>=830 && mouseX<=970) && (mouseY>=230 && mouseY<=280))
    typeJeu=22;
  else if((mouseX>=830 && mouseX<=970) && (mouseY>=290 && mouseY<=340))
    typeJeu=23;
  else if((mouseX>=825 && mouseX<=970) && (mouseY>=700 && mouseY<=750))
  {
    initialise(othello);
    initialiseGUI();
    typeJeu=0;
  }
  else if((mouseX>=0 && mouseX<=800) && (mouseY>=0 && mouseY<=800))
  {
    boolean coup;
    j=mouseX/stepx;i=mouseY/stepy;//pour récupérer la position dans la matrice lors du clic
   if(typeJeu==1)//joueur vs joueur
   {
     if(joueur1!=0)
     {
         coup=jouer(joueur1);
         if(coup)
         {
           joueur1=0;joueur2=2;//pour changer de joueur
           println("tour du joueur2");
         }
     }
     else if(joueur2!=0)
     {
         coup=jouer(joueur2);
         if(coup)
         {
           joueur1=1;joueur2=0;//pour changer de joueur
           println("tour du joueur1");
         }
     }
   }
   else if(typeJeu==21)//niveau facile
   {
     if(joueur1!=0)
     {
         coup=jouer(joueur1);
         if(coup)
         {
           joueur1=0;//pour changer de joueur
           println("tour de l'ordinateur");
         }
     }
     if(joueur1==0)
     {
       profondeur=1;//on fixe la profondeur de descente
       IndexJeu ij = new IndexJeu(-1,-1,-255);
       minMax(othello,2,profondeur,ij,-255);
       if(ij.gain!=-255)
       {
         i=ij.i;j=ij.j;
         ArrayList<Integer> succ = successeurs(i,j,othello,2); //récupérer les successeurs possibles
         ArrayList<Integer> way;
         for(int x=0; x<succ.size();x+=2)
         {
           way=chemin(i,j,othello,2,succ.get(x),succ.get(x+1));
           if(way!=null)
           joue(2, othello, way);//pour jouer      
         }
       }
       joueur1=1;//pour changer de joueur
       println("tour du joueur 1");
     }
   }
   else if(typeJeu==22)//niveau moyen
   {
     if(joueur1!=0)
     {
       coup=jouer(joueur1);
       if(coup)
       {
         joueur1=0;//pour changer de joueur
         println("tour de l'ordinateur");
       }
     }
     if(joueur1==0)
     {
       profondeur=3;//on fixe la profondeur de descente
       IndexJeu ij = new IndexJeu(-1,-1,-255);
       minMax(othello,2,profondeur,ij,-255);
       if(ij.gain!=-255)
       {
         i=ij.i;j=ij.j;
         ArrayList<Integer> succ = successeurs(i,j,othello,2); //récupérer les successeurs possibles
         ArrayList<Integer> way;
         for(int x=0; x<succ.size();x+=2)
         {
           way=chemin(i,j,othello,2,succ.get(x),succ.get(x+1));
           if(way!=null)
           joue(2, othello, way);//pour jouer      
         }
      }
      joueur1=1;//pour changer de joueur
      println("tour du joueur 1");
    }
  }
  else if(typeJeu==23)//niveau difficile
  {
     if(joueur1!=0)
     {
       coup=jouer(joueur1);
       if(coup)
       {
       joueur1=0;//pour changer de joueur
       println("tour de l'ordinateur");
       }
     }
     if(joueur1==0)
     {
       profondeur=6;//on fixe la profondeur de descente
       IndexJeu ij = new IndexJeu(-1,-1,-255);
       //minMax(othello,2,profondeur,ij,-255);
       alphaBeta(othello,2,profondeur,ij,-255,-255,255);
       if(ij.gain!=-255)
       {
         i=ij.i;j=ij.j;
         ArrayList<Integer> succ = successeurs(i,j,othello,2); //récupérer les successeurs possibles
         ArrayList<Integer> way;
         for(int x=0; x<succ.size();x+=2)
         {
           way=chemin(i,j,othello,2,succ.get(x),succ.get(x+1));
           if(way!=null)
           joue(2, othello, way);//pour jouer      
         }
       }
       joueur1=1;//pour changer de joueur
       println("tour du joueur 1");
    }
  }
 }
}

void draw()
{
  for (int x = 0; x < wi; x+=wi/othello.length )
     for (int y = 0; y < he; y+=he/othello.length ) {
      i= y/stepy; j=x/stepx;
      int val=othello[i][j];
      switch(val)
      {
        case 1: fill(255,0,0); ellipse(x+wi/16,y+he/16,75,75); break;//pour afficher le pion rouge
        case 2: fill(0,255,0); ellipse(x+wi/16,y+he/16,75,75); break;//pour afficher le pion vert
      }
    }
 
  //pour calculer les gains
    rouge=0;vert=0;
    for(int x=0;x<othello.length;x++)
       for(int y=0; y<othello[x].length; y++)
          if(othello[x][y]==2) vert++;
          else if(othello[x][y]==1) rouge++;
   score();
   updatePixels();
}


//initialise la matrice de jeu et l'ère de jeu
void initialise(int[][] oth)
{
  fill(200,200,0);
  rect(0,0,800,800);
  for(int i=0;i<oth.length;i++)
     for(int j=0;j<oth[i].length;j++)
        oth[i][j]=0;
  oth[3][3]=2;
  oth[3][4]=1;
  oth[4][3]=1;
  oth[4][4]=2;
  int y1 = 0;
  int y2 = he;
  int i=0;
  while(i<=wi) {
    stroke(0);
    strokeWeight(4);
    line(i, y1, i, y2);
    i+=wi/oth.length;
  }
  y2=wi;
  i=0;
  while(i<=he) {
    stroke(0);strokeWeight(4);
    line(y1, i, y2, i);
    i+=he/oth.length;
  }
  rouge=2;vert=2;
}
//initialise l'interface graphique
void initialiseGUI()
{
    //pour identifier la partie non joueur
  fill(120);
  rect(800,0,800,1000);
  
  //pour identifier le type de jeu 
  fill(125,148,36);
  rect(825,50,150,330);
  fill(0);
  textSize(20);
  text("Options de jeu",830,70);
  
  //Pour joueur contre joueur
  fill(100,255,150);
  rect(830,90,140,50);
  fill(0);
  textSize(15);
  text("Joueur VS Joueur",835,115);
  
  //Contre ordinateur
  fill(255,255,255);
  textSize(15);
  text("Contre ordinateur",830,160);
  
  //Niveau Facile
  fill(100,255,150);
  rect(830,170,140,50);
  fill(0);
  textSize(15);
  text("Niveau Facile",835,195);
  
  //Niveau Moyen
  fill(100,255,150);
  rect(830,230,140,50);
  fill(0);
  textSize(15);
  text("Niveau Moyen",835,255);
  
  //Niveau difficile
  fill(100,255,150);
  rect(830,290,140,50);
  fill(0);
  textSize(15);
  text("Niveau Difficile",835,315);
  
  //Affichage du score
  fill(100,100,200);
  rect(825,400,150,200);
  fill(255);
  textSize(25);
  text("Score",860,425);
  fill(255,255,0);
  textSize(20);
  text("Rouge : "+vert,835,475);
  text("Vert : "+rouge,835,525);
  
  //Rejouer
  fill(200,100,200);
  rect(825,700,150,50);
  fill(255);
  textSize(25);
  text("Rejouer",860,725);
}

//Met à jour l'affichage du score
void score()
{
  fill(100,100,200);
  rect(825,400,150,200);
  fill(255);
  textSize(25);
  text("Score",860,425);
  fill(255,255,0);
  textSize(20);
  text("Rouge : "+rouge,835,475);
  text("Vert : "+vert,835,525);
}


//permet à un joueur de jouer
boolean jouer(int joueur)
{
    boolean b=false;
    ArrayList<Integer> succ = successeurs(i,j,othello,joueur);//récupérer les directions possibles
    ArrayList<Integer> way;
    for(int x=0; x<succ.size();x+=2)
    {
      way=chemin(i,j,othello,joueur,succ.get(x),succ.get(x+1));//récupère le chemin de jeu
      if(way!=null)
      {
        joue(joueur, othello, way);//pour jouer 
        b=true;//on s'assure qu'il a bien jouer
      }
    }
    return b;
}

//Retourne les directions possible
ArrayList<Integer> successeurs(int ii, int jj, int[][] oth, int jeu)
{
  ArrayList<Integer> succ = new ArrayList<Integer>();
  if(oth[ii][jj]==0)
  {
  int k,l;
  
  k=ii-1;
  l=jj;
      if (k>=0 && l>=0 && k<oth.length && l<oth.length)//pas d'overflow
        if(oth[k][l] != 0 && oth[k][l] != jeu)//pas de case vide
        {
             succ.add(k);
              succ.add(l);
        }
  
   
  k=ii+1;
  l=jj;
 if (k>=0 && l>=0 && k<oth.length && l<oth.length)
        if(oth[k][l] != 0 && oth[k][l] != jeu)
        {
             succ.add(k);
              succ.add(l);
        }
      
  k=ii;
  l=jj+1;
  if (k>=0 && l>=0 && k<oth.length && l<oth.length)
        if(oth[k][l] != 0 && oth[k][l] != jeu)
        {
             succ.add(k);
              succ.add(l);
        }
      
  k=ii;
  l=jj-1;
  if (k>=0 && l>=0 && k<oth.length && l<oth.length)
        if(oth[k][l] != 0 && oth[k][l] != jeu)
        {
             succ.add(k);
              succ.add(l);
        }
        
  k=ii+1;
  l=jj-1;
  if (k>=0 && l>=0 && k<oth.length && l<oth.length)
        if(oth[k][l] != 0 && oth[k][l] != jeu)
        {
             succ.add(k);
              succ.add(l);
        }
   
  k=ii+1;
  l=jj+1;
  if (k>=0 && l>=0 && k<oth.length && l<oth.length)
        if(oth[k][l] != 0 && oth[k][l] != jeu)
        {
             succ.add(k);
              succ.add(l);
        }
        
  k=ii-1;
  l=jj+1;
  if (k>=0 && l>=0 && k<oth.length && l<oth.length)
        if(oth[k][l] != 0 && oth[k][l] != jeu)
        {
             succ.add(k);
              succ.add(l);
        }
        
   k=ii-1;
  l=jj-1;
  if (k>=0 && l>=0 && k<oth.length && l<oth.length)
        if(oth[k][l] != 0 && oth[k][l] != jeu)
        {
             succ.add(k);
              succ.add(l);
        }
  }
  return succ;
}

ArrayList<Integer> chemin(int ii, int jj, int[][] oth, int jeu,int xi,int yj)//retourne un chemin si possible
{
  ArrayList<Integer> way = new ArrayList<Integer>();
  int k=ii,l=jj;
  if(k>xi)
  {
    way.add(k);way.add(l);
    if(l==yj)
    {
    k--;
    while(k>=0 && oth[k][l]!=jeu && oth[k][l]!=0)
    {
      way.add(k);way.add(l);
      k--;
    }
    if(k>=0 && oth[k][l]==jeu) return way;
    }
    else if(l<yj)
    {
      k--;l++;
       while(k>=0 && l<oth.length && oth[k][l]!=jeu && oth[k][l]!=0)
      {
        way.add(k);way.add(l);
        k--;l++;
      }
      if(k>=0 && l<oth.length && oth[k][l]==jeu) return way;
    }
    else if (l>yj)
    {
       k--;l--;
       while(k>=0 && l>=0 && oth[k][l]!=jeu && oth[k][l]!=0)
      {
        way.add(k);way.add(l);
        k--;l--;
      }
      if(k>=0 && l>=0 && oth[k][l]==jeu) return way;
    }
  }
  
  else if(k<xi)
  {
    way.add(k);way.add(l);
    if(l==yj)
    {
    k++;
     while(k<oth.length && oth[k][l]!=jeu && oth[k][l]!=0)
    {
      way.add(k);way.add(l);
      k++;
    }
    if(k<oth.length && oth[k][l]==jeu) return way;
    }
    else if(l<yj)
    {
      k++;l++;
       while(k<oth.length && l<oth.length && oth[k][l]!=jeu && oth[k][l]!=0)
      {
        way.add(k);way.add(l);
        k++;l++;
      }
      if(k<oth.length && l<oth.length && oth[k][l]==jeu) return way;
    }
    else if (l>yj)
    {
      k++;l--;
       while(k<oth.length && l>=0 && oth[k][l]!=jeu && oth[k][l]!=0)
      {
        way.add(k);way.add(l);
        k++;l--;
      }
      if(k<oth.length && l>=0 && oth[k][l]==jeu) return way;
    }
  }
  else if(k==xi)
  if(l>yj)
  {
    way.add(k);way.add(l);l--;
    while(l>=0 && oth[k][l]!=jeu && oth[k][l]!=0)
    {
      way.add(k);way.add(l);
      l--;
    }
    if(l>=0 && oth[k][l]==jeu) return way;
  }
  
  else if(l<yj)
  {
    way.add(k);way.add(l);l++;
    while(l<oth.length && oth[k][l]!=jeu && oth[k][l]!=0)
    {
      way.add(k);way.add(l);
      l++;
    }
    if(l<oth.length && oth[k][l]==jeu) return way;
  }
  return null;
}

void joue(int jeu, int[][]oth, ArrayList<Integer> way)//change la couleur des pions
{
  for(int x=0;x<way.size();x+=2)
     oth[way.get(x)][way.get(x+1)]=jeu;
}

//MinMax
void minMax(int[][] oth, int jeu,int profondeur,IndexJeu meilleurCoup,int meilleurScore)
{
  if (profondeur == 0) return;
  else
  {
    int gain;boolean b = false;
    int [][] othbis=new int [oth.length][oth.length];
    for(int i=0;i<oth.length;i++)// on parcourt la matrice
     for(int j=0;j<oth[i].length;j++)
     {
       if(oth[i][j]==0)//on étudie le gain de chaque case vide
       {
         initialiser(oth,othbis); //on prend une matrice image pour évaluer le meilleur coup
         IndexJeu mc = new IndexJeu(meilleurCoup.i,meilleurCoup.j, meilleurCoup.gain);
         ArrayList<Integer> succ = successeurs(i,j,othbis,jeu);//récupérer les successeurs possibles
         ArrayList<Integer> way;
        for(int x=0; x<succ.size();x+=2)//pour chaque direction
        {
           way=chemin(i,j,othbis,jeu,succ.get(x),succ.get(x+1));//trouver le chemin
           if(way!=null)//on vérifie s'il y a un gain
           {
             joue(jeu,othbis,way);//on joue
             b=true;
           }
        }
        if(b)//si c'est un coup gagnant
        {
          b=false;
          gain=gain(2,othbis);//+heuristique[i][j];//on calcule le gain
          if((jeu==2 && gain>=meilleurScore) || (jeu==1 && gain <= meilleurScore)) //si le coup est meilleur que le coup courant, on le garde
          {
            meilleurScore=gain;
            if(jeu==2) minMax(othbis,1,profondeur-1,mc,meilleurScore);
            else minMax(othbis,2,profondeur-1,mc,meilleurScore);
            if(meilleurScore>=meilleurCoup.gain)
            {
              meilleurCoup.i=i;meilleurCoup.j=j;meilleurCoup.gain=meilleurScore;
            }
          }
        }
       }
     }
  }
}

//AlphaBeta
void alphaBeta(int[][] oth, int jeu,int profondeur,IndexJeu meilleurCoup,int meilleurScore, int alpha, int beta)
{
  if (profondeur == 0 || pleine(oth)) return;
  else
  {
    int gain;boolean b=false;
    int [][] othbis=new int [oth.length][oth.length];
    for(int i=0;i<oth.length;i++)// on parcourt la matrice
     for(int j=0;j<oth[i].length;j++)
     {
       if(oth[i][j]==0)//on étudie le gain de chaque case vide
       {
         initialiser(oth,othbis); //on prend une matrice image pour évaluer le meilleur coup
         IndexJeu mc = new IndexJeu(meilleurCoup.i,meilleurCoup.j, meilleurCoup.gain);
         ArrayList<Integer> succ = successeurs(i,j,othbis,jeu);//récupérer les successeurs possibles
         ArrayList<Integer> way;
         for(int x=0; x<succ.size();x+=2)//pour chaque direction
        {
           way=chemin(i,j,othbis,jeu,succ.get(x),succ.get(x+1));//trouver le chemin
           if(way!=null)//on vérifie s'il y a un gain
           {
             joue(jeu,othbis,way);
             b=true;
           }
        }
        if(b)//il y a un gain
        {
          b=false;
          gain=gain(2,othbis)+heuristique[i][j];//on calcule le gain
          if((jeu==2 && gain>meilleurScore) || (jeu==1 && gain < meilleurScore)) //si le coup est meilleur que le coup courant dans le cas de celui qui joue, on le garde
          {
            meilleurScore=gain;
            if(jeu==2 && meilleurScore>=beta)
              alphaBeta(othbis,1,profondeur-1,mc,meilleurScore,beta,meilleurScore);
            else if(jeu==1 && meilleurScore<=alpha)
              alphaBeta(othbis,2,profondeur-1,mc,meilleurScore,beta,meilleurScore);
            if(meilleurScore>=meilleurCoup.gain)
            {
              println(i+"-"+j+" ---"+meilleurScore);
              meilleurCoup.i=i;meilleurCoup.j=j;meilleurCoup.gain=meilleurScore;
            }
          }
        }
       }
     }
  }
}

int gain(int jeu, int[][] oth) //pour calculer le gain d'un joueur 
{
  int gain=0;
  for(int i=0; i<oth.length;i++)
     for(int j=0; j<oth[i].length;j++)
        if(oth[i][j]==jeu) gain++;
   return gain;
}

void initialiser(int[][]oth,int[][] othbis)//pour créer l'image d'une matrice
{
  for(int i=0; i<oth.length;i++)
     for(int j=0; j<oth[i].length;j++)
     othbis[i][j]=oth[i][j];
}

void affiche(int[][]oth)
{
  for(int i=0;i<oth.length;i++)
  {
    for(int j=0;j<oth.length;j++)
       print(oth[i][j] + " ");
    print("\n");
  }
    
}

Boolean pleine (int[][] oth)
{
  for(int i=0;i<oth.length;i++)
    for(int j=0;j<oth.length;j++)
      if(oth[i][j]==0) return false;
  return true;
}