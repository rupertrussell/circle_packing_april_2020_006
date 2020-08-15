// Circle Packing August 2020 v005
// by Rupert Russell 15 August 2020
// Thanks to: http://mattlockyer.com/multimediaprogramming/collisions.html
// https://www.redbubble.com/people/byron/journal/16056584-rb-image-dimensions-and-formats
// 5000×7100 pixels for the large print
// Code on Github at: https://github.com/rupertrussell/circle_packing_april_2020_006
// Artwork on Redbubble at: https://www.redbubble.com/shop/ap/55027426

// String filename = "large_9411×9411.png";
// String filename = "Womens_Graphic_Dress_4020×6090.png";
// String filename = "Mens_Graphic_Tee_3873×4814.png";
// String filename = "Womens_Aline_Dress_6310×6230.png";
// String filename = "Laptop_pouch_&_Case_4600×3000.png";
// String filename = "Spiral_notebook_1756×2481.png";
// String filename = "Hardcover_notebook_3502×2385.png";
// String filename = "Bath_Mat_6480x4320.png";
// String filename = "iPad_Skin_2696x3305.png";
// String filename = "Standard_mug_2700×1120.png";
// String filename = "travel_mug_2376×2024.png";
// String filename = "water_bottle_3160x2180.png";
// String filename = "premium_tee_2875x3900.png";
// String filename = "Large_Print_tee_2875x3900.png";
// String filename = "Duffle_Bag_4050x7800.png";
// String filename = "Throw_blanket_7632x6480.png";
// String filename = "Cotton_Tote_Bag_2280x2760.png";
String filename = "Clock_2940x2940.png";


int margin = 5; 
int maxCells = 100000; 
float minimumCellSize = 10;
int maximumCellSize = 500;
float currentCellSize = 0;
float startradius = 160; //
float shrink = 0.9;
float growAngle = 0;
float distanceBetweenCells = 0;
float cellSize[] = new float[maxCells];
int cellColourR[] = new int[maxCells];
int cellColourG[] = new int[maxCells];
int cellColourB[] = new int[maxCells];
PVector[] vectors = new PVector[maxCells];
boolean clock = true;
float distancefromCenterAndRadius;
float sizeOfClockFace = 2940 /2.1;

void setup()
{
  // size(9411, 9411); // Large
  // size(4020, 6090); // Womens_Graphic_Dress
  // size(3873, 4814); // Mens_Graphic_Tee
  // size(6310, 6230); // Aline Dress
  // size(4600, 3000); // Laptop_pouch_&_Case
  // size(1756, 2481); // Spiral_notebook_1756×2481
  // size(3502, 2385); // Hardcover_notebook_3502×2385
  // size(7632, 6480); // Throw_blanket_7632x6480
  // size(2280, 2760); // Cotton_Tote_Bag_2280x2760
  // size(2875, 3900); // Large_Print_tee_2875x3900.png
  // size(2376, 2024); //  travel_mug_2376×2024
  size(2940, 2940); //    Clock_2940x2940

  background(0);
  noLoop();

  for (int i = 0; i < vectors.length; i++) {
    vectors[i] = new PVector();
  }

  // initial central cell
  vectors[0].x = width/2;
  vectors[0].y = height/2;
  cellSize[0] = startradius;
}

void draw() {
  for (int i = 0; i < maxCells -1; i++) {

    cellColourR[i] = int(random(255));
    cellColourG[i] = int(random(255));
    cellColourB[i] = int(random(255));

    if (clock) {

      if (i == 0) {
        vectors[i].x = width /2;
        vectors[i].y = height /2;
        cellSize[i] = maximumCellSize;
      } else {

        cellSize[i] = int(random(maximumCellSize));
        // make sure cells are within a circle
        vectors[i].x = random(width );
        vectors[i].y = random(height);
        distancefromCenterAndRadius = dist(vectors[i].x, vectors[i].y, width/2, height/2) + cellSize[i];

        if (distancefromCenterAndRadius < sizeOfClockFace) {

          for (int j = 0; j < i; j++) {
            // check distance between current cell and each other cell (NOT self!)
            distanceBetweenCells = dist(vectors[i].x, vectors[i].y, vectors[j].x, vectors[j].y);
            // println("CellSize["+i+"] + cellSize["+j+"]  = " + cellSize[i] + cellSize[j] + " Distance between i "+i+ " and j "+ j + " = " + distanceBetweenCells); 

            if (cellSize[i] > 0) {
              while (cellSize[i] + cellSize[j] > distanceBetweenCells * 2) {
                cellSize[i] = cellSize[i] * shrink;
                if (cellSize[i] <= minimumCellSize ) {
                  cellSize[i] = 0;
                  break;
                }
              }
            }
          }
        } else {
          cellSize[i] = 0;
        }
      }
    } else {
      // not a clock face
      cellSize[i] = int(random(maximumCellSize));
      // make sure cells do not hit the edge of the frame
      vectors[i].x = random(width - cellSize[i] * margin) + cellSize[i] * margin / 2;
      vectors[i].y = random(height - cellSize[i] * margin) + cellSize[i] * margin / 2;

      // check for collision with any previous circle
      // if the distance between the center of the 
      // current circle and every other is less than the radius of 
      // the current circle and test circle current circle it will collide so shrink it and try again

      for (int j = 0; j < i; j++) {
        // check distance between current cell and each other cell (NOT self!)
        distanceBetweenCells = dist(vectors[i].x, vectors[i].y, vectors[j].x, vectors[j].y);
        println("CellSize["+i+"] + cellSize["+j+"]  = " + cellSize[i] + cellSize[j] + " Distance between i "+i+ " and j "+ j + " = " + distanceBetweenCells); 

        if (cellSize[i] > 0) {
          while (cellSize[i] + cellSize[j] > distanceBetweenCells * 2) {
            cellSize[i] = cellSize[i] * shrink;
            if (cellSize[i] <= minimumCellSize ) {
              cellSize[i] = 0;
              break;
            }
          }
        }
      }
    }
  }



  // draw each cell 

  for (int i = 0; i < vectors.length; i++) {
    currentCellSize = cellSize[i];

    for (float x = currentCellSize; x > 0; x = x - currentCellSize / 10) {
      noStroke();
      cellColourR[i] = cellColourR[i] - 10;
      cellColourG[i] = cellColourG[i] - 10;
      cellColourB[i] = cellColourB[i] - 10;
      fill(cellColourR[i], cellColourG[i], cellColourB[i]);
      ellipse(vectors[i].x, vectors[i].y, x, x);
    }
  }

  save(filename);
  print("saved");
  exit();
}
