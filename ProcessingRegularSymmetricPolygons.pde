// Scott Hendrickson
// Twitter: @DrSkippy27
//
// Symmetric shapes-in-circles
// 2012-09-19

class cas {
    ArrayList c0;
    ArrayList c1;
    int dimensionX;
    int mMaximum;

    cas(int _dimensionX, int _mMaximum, ArrayList _c0, ArrayList _c1) {
        dimensionX = _dimensionX;
        mMaximum = _mMaximum;
        c0 = _c0;
        c1 = _c1;
    }   

    void circle(int x0, int y0, int r, PVector cv) {
        // Using cv as a color vector
        stroke(cv.x, cv.y, cv.z);
        ellipse(x0, y0, 2*r, 2*r);
    }

    int inscribed(int r, int dn, float deltaAngle) {
        return int(r * sqrt((1. + cos(dn * deltaAngle))/2.));
    }
    
    void group(int x0, int y0, int r, float startAngle, int n, int dn) {
        float deltaAngle = TWO_PI/n;
        int ci;
        PVector cv;
        int idx;
        int maxStartIdx;
        int lastIdx;
        // Get the list of vertices we are working with to create shapes
        ArrayList verts = createVerts(x0, y0, r, startAngle, n);
        // Bounding circles
        // Radius of inscribed circle
        int p = inscribed(r, dn, deltaAngle);
        cv = (PVector) c0.get(0);
        circle(x0, y0, r, cv);
        // color of inner circle
        ci = (dn % c0.size());
        cv = (PVector) c0.get(ci);
        circle(x0, y0, p, cv);
        // Degeneracy:
        // Have to find all of the cycles
        // that end back at the starting points. 
        // E.g. 14x3=7x7 => 2 and 15x2=6x5 => 3
        maxStartIdx = 0;
        for (int multi = 1; multi < dn; multi ++) {
            if (multi*n % dn == 0 ) {
                maxStartIdx = multi*n/dn;
            }
        }
        // Draw with restarts as needed
        for (int startIdx = 0; startIdx <= maxStartIdx; startIdx ++) {
            lastIdx = startIdx;
            // Don't always have to count up to n, could fix 
            // by making better calculation above
            for (int i = 0; i <= n; i += 1) {
                idx = (lastIdx + dn) % n;
                PVector v1 = (PVector) verts.get(lastIdx);
                PVector v2 = (PVector) verts.get(idx);
                //ci = (n-3) % c1.size();
                ci = (dn-1) % c1.size();
                cv = (PVector) c1.get(ci);
                stroke(cv.x, cv.y, cv.z);
                line(v1.x, v1.y, v2.x, v2.y);
                lastIdx = idx;
            }
        }
    } 

    ArrayList createVerts(int x0, int y0, int r, float startAngle, int n) {
        float deltaAngle = TWO_PI/n;
        float x = 0;
        float y = 0;
        float angle = 0.0;
        ArrayList verts = new ArrayList();
        for (int i = 0; i < n; i++) {
            angle = startAngle + deltaAngle * i;
            x = x0 + r * cos(angle);
            y = y0 + r * sin(angle);
            verts.add(new PVector(x,y));
        }
        return verts;
    }

    void displayConcentric(float startAngle) {
        int x = dimensionX/2;
        int y = dimensionX/2;
        //int x = dimensionX/3;
        //int y = dimensionX/3;
        //
        int r = int(dimensionX/2.2);
        //int r = int(dimensionX/3.2);
        int newR = 0;
        //for (int n = 3; n<= 2*mMaximum + 3; n++) {
        for (int n = 2*mMaximum + 3; n >=3; n--) {
            for (int m = 1; m < (n+1)/2; m++) {
                group(x, y, r, startAngle, n, m);
                newR = inscribed(r, m, TWO_PI/n);
            }
            r = newR;
        }  
    }

    void displayGrid() {
        int dx = dimensionX/mMaximum;
        int r = int(dx/2.2);
        int x;
        int y;
        // grid
        for (int n = 3; n <= 2*mMaximum + 3; n++) {
            y = dx/2 + (n-3)*dx;
            for (int m = 1; m < (n+1)/2; m++) {
                x = dx/2 + (m-1)*dx;
                // vertical
                // group(x, y, r, 0.0, n, m);
                // horizontal
                group(y, dimensionX - x, r, 0.0, n, m);
            }
        }
    }
}

///////////////////////////////////
import processing.pdf.*;
import java.util.Collections;
cas myCas;

void setup() {
    int width = 600;
    
    smooth();
    noLoop();
    noFill();
    
    // Source of colors
    ColorBrewer cb = new ColorBrewer();
    
    // C0 is circles
    //ArrayList c1 = cb.get_Blues_Sequential_9();
    //ArrayList c0 = cb.get_Reds_Sequential_9();

    //
    ArrayList c1 = cb.get_Spectral_Diverging_8();
    ArrayList c0 = cb.get_Dark2_Qualitative_8();  

    //Collections.reverse(c0);
    //Collections.reverse(c1);
    
    // grid vertical
    // size(width, 2*width, PDF, "cas.pdf");
    // grid horizontal
    // size(2*width, width, PDF, "cas.pdf");
    // concentric
    size(width, width, PDF, "cas.pdf");
    // screen vertical
    // size(width, 2*width);
    // screen horizontal
    // size(2*width, width);
    
    //background(25,25,25);
    //background(128,128,128);
    background(230,230,238);
    
    int mMax = 2;
    myCas = new cas(width, mMax, c0, c1);
}

void draw() {
    //myCas.displayGrid();
    myCas.displayConcentric(-TWO_PI/4.);
    // exit required when making pdf
    println("Finished.");
    exit();
}
