import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer player;
FFT         fft;

int[] v;

float fl=0;
float t=0;
float tp=0;
float tn=0;
float median_formula=0;

void setup()
{
  size(1024, 400,P3D);
  frameRate(30);
  // we pass this to Minim so that it can load files from the data directory
  minim = new Minim(this);
  
    player = minim.loadFile("song.mp3",1024);
    
    fft = new FFT( player.bufferSize(), player.sampleRate() );
    
  
  v= new int[fft.specSize()];
  do{
    println("hello");
  for(int k=0;k<v.length;k++){
    v[k]=0;}
  }while (false);
  
player.setGain(-20.0);
    
}

void draw()
{
  background(0);
  stroke(254, 1, 255);
  fft.forward(player.mix);
  
  
  
 for(int i = 0; i < fft.specSize(); i++)
  {
    // draw the line for frequency band i, scaling it up a bit so we can see it
    //line( i, height, i, height - fft.getBand(i)*8 );
    
    line(i*2,height,i*2,height-lerp(v[i],fft.getBand(i)*8,0.15));
    fl=lerp(v[i],fft.getBand(i)*18,0.15);
    v[i]=int(fl);
    
    //tp=t;
    //t=tn;
    //tn=v[i];
    //median_formula=(tp+t+tn)/3;
    //line(i*2,height,i*2,height-lerp(v[i],fft.getBand(i)*10,0,15));
    //fl=lerp(v[i],fft.getBand(i)*10,0,15);
    //v[i]=int(fl);
    
    
    
    
    
  }
  
  
  float posx = map(player.position(), 0, player.length(), 0, width);
  stroke(0,200,0);
  fill(0,200,0);
  rect(2, 2, posx, 10);
  
  fill(255);
  if ( player.isPlaying() )
  {
    text("Press any key to pause playback.", 10, 25 );
  }
  else
  {
    text("Press any key to start playback.", 10, 25 );
  }
}

void keyPressed()
{
  if ( player.isPlaying() )
  {
    player.pause();
  }
  // if the player is at the end of the file,
  // we have to rewind it before telling it to play again
  else if ( player.position() == player.length() )
  {
    player.rewind();
    player.play();
  }
  else
  {
    player.play();
  }
  
}