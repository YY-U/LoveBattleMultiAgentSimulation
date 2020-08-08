//マルチエージェントシミュレータ 
// 女性を巡って男性が争う現実世界の恋愛を模したシミュレーションです
//女性をより多く獲得する男性ほど、移動速度・生命力が高くなります
//男性同士は時々、女性をめぐり喧嘩します
//色が濃いほど生命力が高い男性です
//また、一定の確率で子孫が誕生します



int Length = 300; //空間管理配列の大きさ
//int Length = 400; //空間管理配列の大きさ
int Max_Human = 20; //シミュレータに登場させる男性の数

int time=0;
//int spring=1;
//int summer=2;
//int autumn=3;
//int winter=4;
//int term=100;//各四季の期間を決める
//int sumterm=4*term;
double k=1.0;

int x,y;
//int battle=0;
int damage=0;

//空間管理配列を準備
int[][] MAP = new int[Length][Length]; 

//男性の配列を準備
Human_class[] Human = new Human_class[Max_Human];


//初期化部
void setup() {
  colorMode(HSB);
  size(Length, Length);
  background(0);
  frameRate(30);

  //ここで男性を生成
  for(int i=0; i < Max_Human; i++){
     int k1 = 1; //生きている男性の状態を1、死んでいる場合は 0
     int k2 = int(random(width)); //登場する初期 x座標
     int k3 = int(random(height)); //登場する初期 y座標
     int k4 = int(random(5)); //男性の動作方向をランダムにセット
     int k5 = int(random(5)); //男性の体内時計を0～4の間でセット
     int k6 = 1000 + int(random(800)); //200~400の範囲で体力をセット
     Human[i] = new Human_class(k1,k2,k3,k4,k5,k6);
  }
  
  //空間の状態管理配列を初期化
  for(int i=0; i< Length; i++){
    for(int j=0; j< Length; j++){
      MAP[i][j] = 0;
    }
  }
  
  time=0;
}


// メインループ
void draw() {
 
 //背景を描画
 makeground();
  for(int j=0; j < Max_Human; j++){
    if(Human[j].type == 1){
      damage=200;
      battle(j,damage);  
      //saveFrame("battle.png"); 
    }
  }

 //男性を描画
 for(int j=0; j < Max_Human; j++){
  
  //生きている男性だけ処理  
   if(Human[j].type == 1){
     Human[j].timer ++;  //男性の体内時計を1つカウントアップ
     //男性を描画
     //アニメーションを使っており、体内時計に合わせて動く
     Human[j].draw(); 

    // Human[j].hp = Human[j].hp - 1; //1単位時間で体力を1減らす
     Human[j].hp = Human[j].hp - int(random(1)); //1単位時間で体力を1減らす

     if(Human[j].hp < 0){
       Human[j].type = 0;  //もし体力が0になったら、状態を死に変更
       MAP[Human[j].xpos][Human[j].ypos] = 0;  //状態管理の配列から消去
     }
         
     for(int i=0;i<Max_Human;i++){
       int k=(j+i+Max_Human)%Max_Human;
     if( Human[j].hp>=1500 && Human[j].timer>0 && MAP[Human[j].xpos][Human[j].ypos] == 1&& Human[k].type == 0){
      if(int(random(100))<0){
   
       Human[k].type = 1;  
       Human[k].xpos= Human[j].xpos;
       Human[k].ypos= Human[j].ypos;
       Human[k].direction = ((Human[i].direction)+int(random(4)))%5;//親とは違う方向へ
       //Human[k].direction=int(random(5));
       Human[k].timer=int(random(5));
       Human[k].hp=1000 + int(random(400));

       MAP[Human[k].xpos][Human[k].ypos] = 1;  //
       Human[k].draw();
       print(" 増殖 ");
     }
     }
     }
   }
 }

  //男性を動かす
  for(int j=0; j < Max_Human; j++){
     if(Human[j].type == 1){
       Human[j].drive();
     }
  }
  
  //お互いの衝突判定
  for(int j=0; j < Max_Human; j++){
    if(Human[j].type == 1&& int(random(100))<50 ){
      //damage=100;
      //battle(j,damage);
      Human[j].coll();
    }
  }
  
  //女性の追跡
  for(int j=0; j < Max_Human; j++){
     if(Human[j].type == 1){
       Human[j].eat();
    }
  }
  

   /* if(summer*term<=time%sumterm&&time%sumterm<=autumn*term-1)
    k=2;
    else if(autumn*term<=time%sumterm&&time%sumterm<=winter*term-1)
    k=0.0;
    else
    k=0.5;
    */
    k=1;
    
  //女性を発生
  if(int(random(1000)) < k*100){
    MAP[int(random(Length))][int(random(Length))] = 2;
  }
  
  //女性を描画
  for(int i=0; i < Length ; i++){
    for(int j=0; j < Length; j++){
      if(MAP[i][j] == 2){
        fill(300,100,255);
        ellipse(i,j,6,6);
        triangle(i,j-3,i-4,j+8,i+4,j+8);//胴体 // rect(i-3,j+3,6,5); //胴体
        rect(i-2,j+8,2,5); //左足//rect(i-3,j+8,3,5); //左足
        rect(i,j+8,2,5);   //右足
         
       // rect(i-4,j+3,2,5); //左腕
       // rect(i+2,j+3,2,5); //右腕
        
        /*
        fill(30,255,255);
        ellipse(i,j,10,10);
        fill(35,255,255);
        ellipse(i,j,8,8);
        fill(45,255,255);
        ellipse(i,j,5,5);
        
        stroke(145,255,255);
        line(i-1,j-5,i-1,j-8); 
        line(i,j-5,i,j-7); 
        noStroke(); 
     */   
      } 
    }
  }
  
 // if(autumn*term<=time%sumterm&&time%sumterm<=winter*term-1){
    
  for(int i=0; i < Length ; i++){
    for(int j=0; j < Length; j++){
      if(MAP[i][j] == 2&&int(random(1000)) < 10){
        MAP[i][j] = 0;
        fill(300,30,255);
        ellipse(i,j,6,6);
        triangle(i,j-3,i-4,j+8,i+4,j+8);//胴体 // rect(i-3,j+3,6,5); //胴体
        rect(i-2,j+8,2,5); //左足//rect(i-3,j+8,3,5); //左足
        rect(i,j+8,2,5);   //右足
        noStroke();   
        
    }
   }
 }
 // }
  
time++;
}



//
// 男性のクラスを定義
//

class Human_class
{

  int xpos; //x座標
  int ypos; //y座標
  int type; //男性の状態
  int direction; //男性の動作方向
  int timer; //体内時計
  int hp; //体力
    
  Human_class(int c, int xp, int yp, int dirt, int t, int h) {
    xpos = xp;
    ypos = yp;
    type = c;
    direction = dirt;
    timer = t;
    hp = h;
  }



 //男性を描画する部分
  void draw () {
 
    smooth();
    noStroke();
    
    //体力によって色を変更しましょう
    if(hp>=1400){
    fill(170,255,255);
    }
    if(hp<1400){
    fill(140,255,255); //健康な状態
    }
    
    
    if(hp < 100){
      fill(120,220,255); //体力が落ち始めた状態
    }
  
    if(hp < 50){
       fill(110,140,255); //危険な状態
    } 
    
    //アニメーションは全部で5種類準備
    //体内時間を5で割って、その余りに応じて
    //表示するアニメを決定
    
    int time = timer % 5;
    switch(time){
      
      case 0:
        ellipse(xpos,ypos,6,6);
        rect(xpos-3,ypos+3,6,5); //胴体
        rect(xpos-3,ypos+8,3,5); //左足
        rect(xpos-4,ypos+3,2,5); //左腕
        rect(xpos+2,ypos+3,2,5); //右腕
    
        break;
      case 1:
        ellipse(xpos,ypos,6,6);
        rect(xpos-3,ypos+3,6,5);
        rect(xpos-3,ypos+8,3,4);
        rect(xpos,ypos+8,3,1);        
        break;
       case 2:
        ellipse(xpos,ypos,6,6);
        rect(xpos-3,ypos+3,6,5);
        rect(xpos-3,ypos+8,3,3);
        rect(xpos,ypos+8,3,3);
        break;
        case 3:
        ellipse(xpos,ypos,6,6);
        rect(xpos-3,ypos+3,6,5);
        rect(xpos-3,ypos+8,3,1);
        rect(xpos,ypos+8,3,4);
        break;
        case 4:
        
        //5枚目
        ellipse(xpos,ypos,6,6);
        rect(xpos-3,ypos+3,6,5);
        rect(xpos,ypos+8,3,5);
        rect(xpos-4,ypos+3,2,5); 
        rect(xpos+2,ypos+3,2,5); 
        break;
        
    }
  }


//男性を動かす部分
  void drive () {
    
    //確率5%で動く方向を変更
    if(random(100) < 5){
      //5種類の動きをランダムにセット
      direction = int(random(5));
    }
    
    //動く方向4方向 + 何も動かない
    //合計5種類を準備
    
    switch(direction){
      case 0:
        break; //何も動かず
    
      case 1:
          MAP[xpos][ypos] = 0;
          xpos = (xpos + 1 + width) % width; //右に動かす
          break;
          
      case 2:
          MAP[xpos][ypos] = 0;
          xpos = (xpos - 1 + width) % width; //左に動かす
          break;
          
      case 3:
          MAP[xpos][ypos] = 0;
          ypos = (ypos + 1 + height) % height; //下に動かす
          break;
      
     case 4:
          MAP[xpos][ypos] = 0;
          ypos = (ypos - 1 + height) % height; //上に動かす
          break;
    }
     
   
   //自分の移動先に存在を代入
     MAP[xpos][ypos] = type;  
    
  }
 
  
  //衝突の判定
  void coll() {
    //自分の周囲 10x10 の範囲を探索して、他の男性がいたら避けるようにする
    for(int i = -10; i < 10; i++){
      for(int j = -10; j < 10; j++){
        if (MAP[(xpos+i+width) % width][(ypos+j+height) % height] == 1){
        
          MAP[xpos][ypos] = 0;
        
          //相手から2画素分逃げるようにする
          if(i < 0){
            xpos = (xpos + 2 + width) % width; 
          }
          if(i > 0){
            xpos = (xpos - 2 + width) % width;
          }
          
          //相手から2画素分逃げるようにする
          if(j < 0){
            ypos = (ypos + 2 + height) % height;
          }
          if(j > 0){
            ypos = (ypos - 2 + height) % height;
          }
          
          MAP[xpos][ypos] = type; 
          
        }
      }//for
    }//for
   
    
    
    
  }
  
  
  //女性の獲得
  
  void eat(){
    
    int action = 0;
    int kr=150;
    int ks=1;
    if(hp>=1400){
    kr=2*kr;
    ks=2*ks;
    }
  
    
    for(int r = 0; r < kr; r++){
      for(int s = 0; s < 360; s=s+10){
          
      int i = int(r * cos(radians(s)));
      int j = int(r * sin(radians(s)));
          
      if ((MAP[(xpos+i+width) % width][(ypos+j+height) % height] == 2)){       
        
            MAP[xpos][ypos] = 0;
             
            if((i > 0)&&(action==0)){
              direction = 1;
              xpos = (xpos + ks + width) % width; //右に動かす
              action = 1;
            }
            
            if((i < 0)&&(action==0)){
               direction = 2;
               xpos = (xpos - ks + width) % width; //左に動かす
               action = 1;
            }
          
            if((j > 0)&&(action==0)){
              direction = 3;
              ypos = (ypos + ks + height) % height; //下に動かす
              action = 1;
            }
            if((j < 0)&&(action==0)){
              direction = 4;
              ypos = (ypos - ks + height) % height; //上に動かす
              action = 1;
            }       
      }
      if(action == 1)
       break;
      }
    }
    
      //もし男性が女性のもとへたどり着いたら、
            //エネルギーが回復
            if((MAP[xpos][ypos] == 2)){
             hp = hp + 100;
             //hp=1500;
              
            }
            
            MAP[xpos][ypos] = 1;
  }
  
  
  
}
//男性同時の戦い
//負ければダメージを被る
void battle(int n,int damage){
  int temp=20;
 
     for(int i = -10; i < 10; i++){
      for(int j = -10; j < 10; j++){
  
        if (MAP[(Human[n].xpos+width) % width][(Human[n].ypos+height) % height]==1&&MAP[(Human[n].xpos+i+width) % width][(Human[n].ypos+j+height) % height] == 1&&(!(j==0&&i==0))){
      for(int k=0;k<Max_Human;k++){
        if( (Human[n].xpos+i+width) % width==(Human[k].xpos+width) % width && (Human[n].ypos+j+height) % height == (Human[k].ypos+height) % height)
        temp=k;
      }
          
          if(random(100)<25){
            if(random(100)<50){
           Human[n].hp=Human[n].hp-damage;
           Human[temp].hp=Human[temp].hp-damage;
           print(" battle_and_damage ");   
            fill(15,230,255);
            ellipse( (Human[n].xpos+width) % width,(Human[n].ypos+height) % height ,30,30);
            fill(15,230,255);
            ellipse( (Human[temp].xpos+width) % width,(Human[temp].ypos+height) % height,30,30);
            
           }
           else{
             if(random(100)<50){
                Human[n].hp=Human[n].hp-damage;
                fill(15,230,255);
                ellipse( (Human[n].xpos+width) % width,(Human[n].ypos+height) % height ,30,30);
             }
             else{
                Human[temp].hp=Human[temp].hp-damage;
                fill(15,230,255);
                ellipse( (Human[temp].xpos+width) % width,(Human[temp].ypos+height) % height,30,30);
             }
             
           }
            
           }
          
          
        }
      }
     }
  }

//背景を描画
void makeground(){
  /*if(0<=time%sumterm&&time%sumterm<=spring*term-1){
  fill(240,40,200); //春色
  rect(0,0,width,height);
  }
  if(spring*term<=time%sumterm&&time%sumterm<=summer*term-1){
  fill(108,200,200); //夏色
  rect(0,0,width,height);
  }
  if(summer*term<=time%sumterm&&time%sumterm<=autumn*term-1){
  fill(29,200,200); //秋色
  rect(0,0,width,height);
  }
  if(autumn*term<=time%sumterm&&time%sumterm<=winter*term-1){
  fill(128,100,100); //冬色
  rect(0,0,width,height);
  }*/
  
  fill(300,30,255);
  rect(0,0,width,height);
  
}

void mousePressed() {
 saveFrame("human.png"); 
}
