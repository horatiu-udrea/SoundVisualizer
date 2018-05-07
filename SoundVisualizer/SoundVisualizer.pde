import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer player;
FFT         fft;

int[] v;

float fl=0;
float LerpAmount=0.15;
float BandMultiplier=9;

void setup()
{
  size(1024, 400, P3D);
  frameRate(30);

  // we pass this to Minim so that it can load files from the data directory
  minim = new Minim(this);

  player = minim.loadFile("song.mp3", 1024);

  fft = new FFT( player.bufferSize(), player.sampleRate() );


  v= new int[fft.specSize()];
  do {
    println(fft.specSize());
    for (int k=0; k<v.length; k++) {
      v[k]=0;
    }
  } while (false);

  player.setGain(-20.0);
}

void draw()
{
  background(36);
  stroke(183, 5, 241);
  fft.forward(player.mix);

  float Median=0;

  //for(int i = 0; i < fft.specSize(); i++)
  // {
  //   // draw the line for frequency band i, scaling it up a bit so we can see it
  //   //line( i, height, i, height - fft.getBand(i)*8 );

  //   fl=lerp(v[i],fft.getBand(i)*BandMultiplier,LerpAmount);
  //   line(i*2,height,i*2,height-fl);
  //   v[i]=int(fl);
  // }

  //first line
  fl=lerp(v[0], fft.getBand(0)*BandMultiplier, LerpAmount);
  line(1*2, height, 1*2, height-fl);
  v[0]=int(fl);

  for (int i = 1; i < fft.specSize()-1; i++)
  {
    // draw the line for frequency band i, scaling it up a bit so we can see it
    //line( i, height, i, height - fft.getBand(i)*8 );
    Median=(v[i-1]+fft.getBand(i)*BandMultiplier+v[i+1])/3;
    fl=lerp(v[i], Median, LerpAmount);
    line(i*2, height, i*2, height-fl);
    v[i]=int(fl);
  }
  //last line
  fl=lerp(v[fft.specSize()-1], fft.getBand(fft.specSize()-1)*BandMultiplier, LerpAmount);
  line(1*2, height, 1*2, height-fl);
  v[fft.specSize()-1]=int(fl);




  float posx = map(player.position(), 0, player.length(), 0, width);
  stroke(0, 200, 0);
  fill(0, 200, 0);
  rect(2, 2, posx, 10);

  fill(255);
  if ( player.isPlaying() )
  {
    text("Press any key to pause playback.", 10, 25 );
  } else
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
  } else
  {
    player.play();
  }
}
