/**
 * CP1919
 * SAY HI TO JOY DIVISION
 *
 * ----------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE" (Revision 42):
 * <xiatwo@gmail.com> wrote this file. As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy me a beer in return Dongzhi Xia
 * ----------------------------------------------------------------------------
 */
 
class WaveformRenderer implements AudioListener
{
  private float[] left;
  private float[] right;
  private int lineW = 256;
  private int lineS = 60;
  private float [][] lines;
  private float [] filterr;
  
  WaveformRenderer ()
  {
    left = null; 
    right = null;
    
    lines = new float[100][lineW];
    
    //Create filter
    filterr = new float[256];
    for (int i = 0; i < 256; i++){
      filterr[i]= pow( 1 - (abs(i-128) / 190.00) , 4)*2.5;
    }
  }
  
  synchronized void samples(float[] samp)
  {
    left = samp;
  }
  
  synchronized void samples(float[] sampL, float[] sampR)
  {
    left = sampL;
    right = sampR;
  }
  
  synchronized void draw()
  {
    // we've got a stereo signal if right or left are not null
    if ( left != null && right != null )
    {
      
      //Spread
      for (int i = 0; i < 99; i++){
        for(int j = 0; j < lineW; j++){
          lines[i][j] = lines[i+1][j];
        }
      }
      
      //Store spectrum data 
      for(int i = 0; i < 256; i++){
          lines[99][255-i] = right[i];
      }
      
      
      //Draw lines
      int lineP = 80;
      for(int i = 0; i< 99; i++){
        fill(0);
        stroke(0);
        for(int j = 0; j< lineW; j++){
            line((width-lineW)/2+j,lineP,(width-lineW)/2+j, lineP-abs(lines[i][j])*filterr[j]*lineS);  
        }
        
        noFill();
        stroke(255);
        strokeWeight(1);
        beginShape();
        for(int j = 0; j< lineW; j++){
          vertex((width-lineW)/2+j, lineP-abs(lines[i][j])*filterr[j]*lineS-0.5);
        }
        endShape();
        lineP = lineP + 5;
      }
    }
  }
}
