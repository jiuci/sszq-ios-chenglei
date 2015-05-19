#include "RtBioRuler.h"
#include <fstream>

#include "RtMath.h"
#include "RtHist.h"

#define BIORULER_DISPLAY1   "BioRuler Display 1"
#define BIORULER_DISPLAY2   "BioRuler Display 2"
#define BIORULER_DISPLAY3   "BioRuler Display 3"
#define BIORULER_DISPLAY4   "BioRuler Display 4"
#define BIORULER_DISPLAY5   "BioRuler Display 5"

#define CASCADE_FACE_FILE   "haarcascade_frontalface_default.xml"
#define CASCADE_NOSE_FILE   "haarcascade_mcs_nose.xml"
#define CASCADE_EYES_FILE0  "haarcascade_eye.xml"
#define CASCADE_EYES_FILE1  "haarcascade_mcs_lefteye.xml"
#define CASCADE_EYES_FILE2  "haarcascade_mcs_righteye.xml"

namespace rt
{
    
    inline CvPoint GetCenter(const CvRect& rect)
    {
        return cvPoint( rect.x+rect.width/2, rect.y+rect.height/2 );
    }

    inline CvSize operator*(const CvSize& s, float v)
    {
        return cvSize(
            int( ToInt( s.width*v ) ),
            int( ToInt( s.height*v ) )
            );
    }

    inline CvRect operator*(const CvRect& r, float v)
    {
        return cvRect(
            int( ToInt(r.x      * v) ),
            int( ToInt(r.y      * v) ),
            int( ToInt(r.width  * v) ),
            int( ToInt(r.height * v) )
            );
    }

    inline float Distance(const CvPoint& a, const CvPoint& b)
    {
        return sqrt( float( (a.x-b.x)*(a.x-b.x) + (a.y-b.y)*(a.y-b.y) ) );
    }

    inline bool operator!=(const CvPoint& a, const CvPoint& b)
    {
        return (a.x != b.x) || (a.y != b.y);
    }

    inline CvPoint operator+(const CvPoint& a, const CvPoint& b)
    {
        return cvPoint( a.x + b.x, a.y + b.y );
    }

    inline CvPoint operator-(const CvPoint& a, const CvPoint& b)
    {
        return cvPoint( a.x - b.x, a.y - b.y );
    }

    inline CvPoint operator*(const CvPoint& a, float v)
    {
        return cvPoint( a.x*v, a.y*v );
    }

    inline CvPoint operator*(float v, const CvPoint& a)
    {
        return cvPoint( a.x*v, a.y*v );
    }

    inline CvPoint operator/(const CvPoint& a, float v)
    {
        return cvPoint( a.x/v, a.y/v );
    }

    inline CvScalar operator+(const CvScalar &s1, const CvScalar &s2)
    {
        CvScalar r;
        for (int i = 0; i < 4; ++i)
        {
            r.val[i] = s1.val[i] + s2.val[i];
        }
        return r;
    }
    inline CvScalar operator-(const CvScalar &s1, const CvScalar &s2)
    {
        CvScalar r;
        for (int i = 0; i < 4; ++i)
        {
            r.val[i] = s1.val[i] - s2.val[i];
        }
        return r;
    }
    inline CvScalar operator*(const CvScalar &s, float v)
    {
        CvScalar r;
        for (int i = 0; i < 4; ++i)
        {
            r.val[i] = s.val[i] * v;
        }
        return r;
    }
    inline CvScalar operator/(const CvScalar &s, float v)
    {
        CvScalar r;
        for (int i = 0; i < 4; ++i)
        {
            r.val[i] = s.val[i] / v;
        }
        return r;
    }

    bool GrayImageSegment(const IplImage* pInput, IplImage* pResult, int nClusters)
    {
        CvMat*samples   = cvCreateMat((pInput->width)* (pInput->height),1, CV_32FC1);
        CvMat*clusters  = cvCreateMat((pInput->width)* (pInput->height),1, CV_32SC1);
        CvMat*centers   = cvCreateMat(nClusters, 1, CV_32FC1);
//        float step      = 255.0f / ( (float)nClusters - 1 );

        CvScalar s;
        int iter = 0;
        for (int h = 0; h < pInput->height; ++h)
        {
            for (int w = 0; w < pInput->width; ++w)
            {
                s.val[0] = (float)cvGet2D(pInput, h, w).val[0];
                cvSet2D(samples, iter++, 0, s);
            }
        }

        cvKMeans2(samples, nClusters, clusters, cvTermCriteria(CV_TERMCRIT_ITER + CV_TERMCRIT_EPS,100, 1.0), 1, 0, 0, centers);

        vector<float>   colors;
        vector<int>     counter;
        colors.resize( nClusters, 0.0f );
        counter.resize( nClusters, 0 );

        iter = 0;
        for (int h = 0; h < pInput->height; ++h)
        {
            for (int w = 0; w < pInput->width; ++w)
            {
                int idx = clusters->data.i[iter];
                colors[idx] += cvGet2D(samples, iter, 0).val[0];
                counter[idx]++;
                ++iter;
            }
        }
        for (int i = 0; i < nClusters; ++i)
        {
            if (counter[i] > 0)
            {
                colors[i] /= counter[i];
            }
        }

        iter = 0;
        for (int h = 0; h < pInput->height; ++h)
        {
            for (int w = 0; w < pInput->width; ++w)
            {
                int idx = clusters->data.i[iter];
                s.val[0] = colors[idx];
                cvSet2D( pResult, h, w, s );
                ++iter;
            }
        }

        cvReleaseMat( &samples );
        cvReleaseMat( &clusters );
        cvReleaseMat( &centers );

        return true;
    }

    bool ColorImageSegment(const IplImage* pInput, IplImage* pResult, int nClusters)
    {
        CvMat*samples   = cvCreateMat((pInput->width)* (pInput->height),1, CV_32FC3);
        CvMat*clusters  = cvCreateMat((pInput->width)* (pInput->height),1, CV_32SC1);
//        float step      = 255.0f / ( (float)nClusters - 1 );

        int iter = 0;
        for (int h = 0; h < pInput->height; ++h)
        {
            for (int w = 0; w < pInput->width; ++w)
            {
                cvSet2D( samples, iter++, 0, cvGet2D(pInput, h, w) );
            }
        }

        cvKMeans2(samples, nClusters, clusters, cvTermCriteria(CV_TERMCRIT_ITER, 100, 1.0) );

        vector< CvScalar >      colors;
        vector<int>             counter;
        colors.resize( nClusters, cvScalar(0) );
        counter.resize( nClusters, 0 );

        iter = 0;
        for (int h = 0; h < pInput->height; ++h)
        {
            for (int w = 0; w < pInput->width; ++w)
            {
                int idx = clusters->data.i[iter];
                colors[idx] = colors[idx] + cvGet2D(samples, iter, 0);
                counter[idx]++;
                ++iter;
            }
        }
        for (int i = 0; i < nClusters; ++i)
        {
            if (counter[i] > 0)
            {
                colors[i] = colors[i] / counter[i];
            }
        }

        iter = 0;
        for (int h = 0; h < pInput->height; ++h)
        {
            for (int w = 0; w < pInput->width; ++w)
            {
                int idx = clusters->data.i[iter];
                cvSet2D( pResult, h, w, colors[idx] );
                ++iter;
            }
        }

        cvReleaseMat( &samples );
        cvReleaseMat( &clusters );

        return true;
    }

    void Analyse(const vector<CvRect> &boxes, vector<CvPoint>& cs, vector<float>& ws)
    {
        size_t num = boxes.size();
        vector<CvPoint> points;
        for (size_t i = 0; i < num; ++i)
        {
            points.push_back( GetCenter( boxes[i] ) );
        }

        if (num == 1)
        {
            cs.push_back( points[0] );
            ws.push_back( 1.0f );
        }
        else
        {
            bool bFound = false;
            CvPoint c1 = points[0], c2;
            for (size_t i = 1; i < num; ++i)
            {
                if (c1 != points[i])
                {
                    c2 = points[i];
                    bFound = true;
                    break;
                }
            }
            if (!bFound)
            {
                cs.push_back( points[0] );
                ws.push_back( 1.0f );
            }
            else
            {

                vector<CvPoint> set1, set2;

                float lastD1 = 0.0f, lastD2 = 0.0f;

                int counter = 5;
                while (counter > 0)
                {
                    set1.clear();
                    set2.clear();

                    float D1 = 0.0f, D2 = 0.0f;
                    for (size_t i = 0; i < num; ++i)
                    {
                        const CvPoint& pp = points[i];
                        float d1 = Distance(c1, pp);
                        float d2 = Distance(c2, pp);
                        if (d1 <= d2)
                        {
                            set1.push_back(pp);
                            D1 += d1;
                        }
                        else
                        {
                            set2.push_back(pp);
                            D2 += d2;
                        }
                    }

                    if ( fabs(lastD1-D1) < 1e-5 && fabs(lastD2-D2) < 1e-5 )
                    {
                        break;
                    }

                    lastD1 = D1;
                    lastD2 = D2;

                    c1 = set1[0];
                    for (size_t i = 1; i < set1.size(); ++i)
                    {
                        c1 = c1 + set1[i];
                    }
                    c1 = c1 / set1.size();

                    c2 = set2[0];
                    for (size_t i = 1; i < set2.size(); ++i)
                    {
                        c2 = c2 + set2[i];
                    }
                    c2 = c2 / set2.size();
                    --counter;
                }

                cs.push_back(c1);
                cs.push_back(c2);
                ws.push_back( float(set1.size())/float(num) );
                ws.push_back( float(set2.size())/float(num) );
            }
        }
    }

    RtBioRuler::RtBioRuler() : m_faceImageWithCard(NULL), m_faceImage(NULL)
    {
        NSString *itemName;
        NSArray *aArray;
        NSString *filename;
        NSString *sufix;
        NSString *targetXML;

        
        itemName = [NSString stringWithUTF8String:CASCADE_FACE_FILE];
        aArray = [itemName componentsSeparatedByString:@"."];
        filename = [aArray objectAtIndex:0];
        sufix = [aArray objectAtIndex:1];
        targetXML = [[NSBundle mainBundle] pathForResource:filename ofType:sufix];
        m_faceCascadeClassifier  = (CvHaarClassifierCascade*)cvLoad( [targetXML cStringUsingEncoding:NSUTF8StringEncoding],  0, 0, 0 );

        itemName = [NSString stringWithUTF8String:CASCADE_NOSE_FILE];
        aArray = [itemName componentsSeparatedByString:@"."];
        filename = [aArray objectAtIndex:0];
        targetXML = [[NSBundle mainBundle] pathForResource:filename ofType:sufix];
        m_noseCascadeClassifier  = (CvHaarClassifierCascade*)cvLoad( [targetXML cStringUsingEncoding:NSUTF8StringEncoding],  0, 0, 0 );
        
        itemName = [NSString stringWithUTF8String:CASCADE_EYES_FILE0];
        aArray = [itemName componentsSeparatedByString:@"."];
        filename = [aArray objectAtIndex:0];
        targetXML = [[NSBundle mainBundle] pathForResource:filename ofType:sufix];
        m_eyeCascadeClassifier0  = (CvHaarClassifierCascade*)cvLoad( [targetXML cStringUsingEncoding:NSUTF8StringEncoding],  0, 0, 0 );
        
        itemName = [NSString stringWithUTF8String:CASCADE_EYES_FILE1];
        aArray = [itemName componentsSeparatedByString:@"."];
        filename = [aArray objectAtIndex:0];
        targetXML = [[NSBundle mainBundle] pathForResource:filename ofType:sufix];
        m_eyeCascadeClassifier1  = (CvHaarClassifierCascade*)cvLoad( [targetXML cStringUsingEncoding:NSUTF8StringEncoding],  0, 0, 0 );
        
        itemName = [NSString stringWithUTF8String:CASCADE_EYES_FILE2];
        aArray = [itemName componentsSeparatedByString:@"."];
        filename = [aArray objectAtIndex:0];
        targetXML = [[NSBundle mainBundle] pathForResource:filename ofType:sufix];
        m_eyeCascadeClassifier2  = (CvHaarClassifierCascade*)cvLoad( [targetXML cStringUsingEncoding:NSUTF8StringEncoding],  0, 0, 0 );
        
//        m_noseCascadeClassifier         = (CvHaarClassifierCascade*)cvLoad( CASCADE_NOSE_FILE,  0, 0, 0 );
//        m_eyeCascadeClassifier0         = (CvHaarClassifierCascade*)cvLoad( CASCADE_EYES_FILE0, 0, 0, 0 );
//        m_eyeCascadeClassifier1         = (CvHaarClassifierCascade*)cvLoad( CASCADE_EYES_FILE1, 0, 0, 0 );
//        m_eyeCascadeClassifier2         = (CvHaarClassifierCascade*)cvLoad( CASCADE_EYES_FILE2, 0, 0, 0 );

        m_faceStorageMemory             = cvCreateMemStorage(0);
        m_noseStorageMemory             = cvCreateMemStorage(0);
        m_cardStorageMemory             = cvCreateMemStorage(0);
        m_eyesStorageMemory             = cvCreateMemStorage(0);
        m_lineStorageMemory             = cvCreateMemStorage(0);

        //init standard card size(85.6mm X 53.98mm)
        m_idCardSize.width              = 85.6f;
        m_idCardSize.height             = 54.0f;

        //init nose focus domain, come from test data.
        m_noseFocusDomain.xOffset       = 0.24f;    // x_offset     / face_size
        m_noseFocusDomain.yOffset       = 0.34f;    // y_offset     / face_size
        m_noseFocusDomain.xRange        = 0.52f;    // x_range      / face_size
        m_noseFocusDomain.yRange        = 0.63f;    // y_range      / face_size
        m_noseFocusDomain.xMinLength    = 0.22f;    // x_min_length / face_size
        m_noseFocusDomain.xMaxLength    = 0.38f;    // x_max_length / face_size
        m_noseFocusDomain.yMinLength    = 0.19f;    // y_min_length / face_size
        m_noseFocusDomain.yMaxLength    = 0.32f;    // y_max_length / face_size
        m_noseFocusDomain.xAvgCenter    = 0.496f;   // x_center_avg / face_size
        m_noseFocusDomain.yAvgCenter    = 0.626f;   // y_center_avg / face_size
        m_noseFocusDomain.xAvgLength    = 0.296f;   // x_length_avg / face_size;
        m_noseFocusDomain.yAvgLength    = 0.247f;   // y_length_avg / face_size;
        
        //cvNamedWindow( BIORULER_DISPLAY1, CV_WINDOW_AUTOSIZE );
        //cvNamedWindow( BIORULER_DISPLAY2, CV_WINDOW_AUTOSIZE );
        //cvNamedWindow( BIORULER_DISPLAY3, CV_WINDOW_AUTOSIZE );
        //cvNamedWindow( BIORULER_DISPLAY4, CV_WINDOW_AUTOSIZE );
        //cvNamedWindow( BIORULER_DISPLAY5, CV_WINDOW_AUTOSIZE );
    }

    RtBioRuler::~RtBioRuler()
    {
        if (NULL != m_faceStorageMemory)
        {
            cvReleaseMemStorage( &m_faceStorageMemory );
            m_faceStorageMemory = NULL;
        }
        if (NULL != m_noseStorageMemory)
        {
            cvReleaseMemStorage( &m_noseStorageMemory );
            m_noseStorageMemory = NULL;
        }
        if (NULL != m_cardStorageMemory)
        {
            cvReleaseMemStorage( &m_cardStorageMemory );
            m_cardStorageMemory = NULL;
        }
        if (NULL != m_eyesStorageMemory)
        {
            cvReleaseMemStorage( &m_eyesStorageMemory );
            m_eyesStorageMemory = NULL;
        }
        if (NULL != m_lineStorageMemory)
        {
            cvReleaseMemStorage( &m_lineStorageMemory );
            m_lineStorageMemory = NULL;
        }
        
        //cvDestroyAllWindows();
    }

    bool RtBioRuler::Init(IplImage* inputImage , float& faceWidth )
    {
        CvRect faceRect, noseRect;
        CvPoint lEye, rEye;

        bool bRet = true;
        bRet = DetectFace( inputImage, faceRect, noseRect );
        if (!bRet)
        {
            return false;
        }

        float scale     = faceRect.width / faceRect.width;
        faceRect        = faceRect * scale;
        noseRect        = noseRect * scale;

        CvSize newSize  = cvSize( ToInt(inputImage->width*scale), ToInt(inputImage->height*scale) );

        IplImage* rawImage   = cvCreateImage( newSize, inputImage->depth, inputImage->nChannels );
        cvResize(inputImage, rawImage, CV_INTER_CUBIC);

        bRet = DetectEyes( rawImage, faceRect, noseRect, lEye, rEye );
        if (!bRet)
        {
            cvReleaseImage( &rawImage );
            return false;
        }

        int eyePixels = ToInt( Distance(lEye, rEye) );

        int facePixels = 0;
        DetectFaceBorder( rawImage,  faceRect, lEye, rEye, facePixels);


        int cardPixels;
        bool bWidthOrHeight = true;
        bRet = DetectCard( rawImage, noseRect, eyePixels, cardPixels, bWidthOrHeight);
        if (!bRet)
        {
            cvReleaseImage( &rawImage );
            return false;
        }

        float cardSize = bWidthOrHeight ? m_idCardSize.width : m_idCardSize.height;

        m_pupillaryDistance = cardSize * float(eyePixels) / float(cardPixels);
        m_faceWidth = cardSize * float(facePixels) / float(cardPixels);
        faceWidth = m_faceWidth;
        
        cvReleaseImage( &rawImage );
        return bRet;
    }

    bool RtBioRuler::Detect(IplImage* inputImage, CvPoint& lEye, CvPoint& rEye, float& faceWidth,int& facePixels)
    {
        CvRect faceRect, noseRect;
//        int cardPixels;
//        bool bWidthOrHeight;

        bool bRet = true;
        bRet = DetectFace( inputImage, faceRect, noseRect );
        if (!bRet)
        {
            faceWidth = -1;
            return false;
        }

        float scale     = faceRect.width / faceRect.width;
        faceRect        = faceRect * scale;
        noseRect        = noseRect * scale;

        CvSize newSize  = cvSize( ToInt(inputImage->width*scale), ToInt(inputImage->height*scale) );

        IplImage* rawImage   = cvCreateImage( newSize, inputImage->depth, inputImage->nChannels );
        cvResize(inputImage, rawImage, CV_INTER_CUBIC);

        bRet = DetectEyes( rawImage, faceRect, noseRect, lEye, rEye );
        if (!bRet)
        {
            faceWidth = -2;
            cvReleaseImage( &rawImage );
            return false;
        }

        int eyePixels = ToInt( Distance(lEye, rEye) );

        facePixels = 0;
        DetectFaceBorder( rawImage,  faceRect, lEye, rEye, facePixels);
        
        cvReleaseImage( &rawImage );
        m_faceWidth = m_pupillaryDistance * float(facePixels) / float(eyePixels);
        faceWidth = m_faceWidth;

        cvReleaseImage( &rawImage );
        
        lEye = lEye / scale;
        rEye = rEye / scale;
        return bRet;
    }

    bool RtBioRuler::DetectFace(IplImage* inputImage, CvRect& faceRect, CvRect& noseRect)
    {
        bool bRet = false;
        
        
        
        int minFaceSize = (inputImage->width < inputImage->height ? inputImage->width : inputImage->height) / 3;
        minFaceSize = minFaceSize > 128 ? minFaceSize : 128;

        cvClearMemStorage(m_faceStorageMemory);
        

        CvSeq* faces = cvHaarDetectObjects(
            inputImage,
            m_faceCascadeClassifier,
            m_faceStorageMemory,
            1.1, 3, 0,
            cvSize(minFaceSize, minFaceSize)
            );
        for (int face_idx = 0; face_idx < faces->total; ++face_idx)
        {
            faceRect    = *(CvRect*)cvGetSeqElem(faces, face_idx);
            bRet       = DetectNose(inputImage, faceRect, noseRect);
            if (bRet)
            {
                break;
            }
        }

        return bRet;
    }

    void Draw(IplImage* pImage, const IntPair& split, CvScalar& color)
    {
        cvLine(pImage, cvPoint(split.first+1,  0), cvPoint(split.first+1,  pImage->height), color);
        cvLine(pImage, cvPoint(split.second-1, 0), cvPoint(split.second-1, pImage->height), color);
    }

    void Draw(IplImage* pImage, const vector<IntPair>& splits, CvScalar& color)
    {
        for (int i = 0; i < splits.size(); ++i)
        {
            cvLine(pImage, cvPoint(splits[i].first+1,  0), cvPoint(splits[i].first+1,  pImage->height), color);
            cvLine(pImage, cvPoint(splits[i].second-1, 0), cvPoint(splits[i].second-1, pImage->height), color);
        }
    }

    int FindFaceBorder(IplImage* inputImage, CvRect& domain, bool bFromLeftOrRight)
    {
        int position = -1;
       // int block_size = 5;

        IplImage* grayImage     = cvCreateImage( cvSize(domain.width, domain.height), IPL_DEPTH_8U, 1);
        IplImage* rawImage      = cvCreateImage( cvSize(domain.width, domain.height), inputImage->depth, inputImage->nChannels);

        cvSetImageROI( inputImage, domain );
        cvCvtColor( inputImage, grayImage, CV_BGR2GRAY);
        cvCopyImage( inputImage, rawImage );
        cvResetImageROI( inputImage );

        //gray
        {
            RtHist hist;
            hist.Init   ( grayImage, true );
            hist.Smooth ( domain.height/2 );
            hist.Analyse( domain.height/2 );
            IntPair split = hist.FindSplit(domain.height/2, bFromLeftOrRight);

            ///Draw( rawImage, split, CV_RGB(255, 0, 0) );
            //IplImage* xx = hist.CreateHistImage(true);
            //cvShowImage(BIORULER_DISPLAY1, rawImage);
            //cvShowImage(BIORULER_DISPLAY5, xx);
            //cvReleaseImage( &xx );

            CvRect splitDomain;
            splitDomain.x     = split.first;
            splitDomain.y     = 0;
            splitDomain.width = split.second - split.first;
            splitDomain.height= domain.height;

            IplImage* xxx     = cvCreateImage( cvSize(splitDomain.width, splitDomain.height), IPL_DEPTH_8U, 1);
            cvSetImageROI( grayImage, splitDomain );
            cvCopyImage( grayImage, xxx );
            cvResetImageROI( grayImage );
            GrayImageSegment(xxx, xxx, 2);
            cvEqualizeHist(xxx, xxx);
            cvCanny( xxx, xxx, 75, 300, 3 );

            hist.Init( xxx, true );
            hist.Smooth( 3 );
            int peak = hist.FindPeak();
            peak = (-1 != peak) ? peak : splitDomain.width/2;
            position = peak + splitDomain.x + domain.x;
            cvReleaseImage( &xxx );

            //cvShowImage(BIORULER_DISPLAY2, grayImage);

            //cvWaitKey(0);
        }
        cvReleaseImage( &grayImage );
        cvReleaseImage( &rawImage );

        return position;
    }


    bool RtBioRuler::DetectFaceBorder(IplImage* inputImage, CvRect& faceRect, const CvPoint& lEye, const CvPoint& rEye, int &facePixels)
    {
        float eyeDistance = Distance(lEye, rEye);

        CvRect domain0, domain1, domain2;

        domain0.x       = faceRect.x;
        domain0.y       = (lEye.y + rEye.y) / 2 - ToInt( eyeDistance/12.0f );
        domain0.width   = faceRect.width;
        domain0.height  = ToInt( eyeDistance/5.0f );

        domain1.x       = faceRect.x;
        domain1.y       = (lEye.y + rEye.y) / 2 - ToInt( eyeDistance/12.0f );
        domain1.width   = ToInt( (lEye.x - faceRect.x)*0.7f );
        domain1.height  = ToInt( eyeDistance/5.0f );

        domain2.x       = rEye.x + ToInt(  (faceRect.x+faceRect.width-rEye.x)*0.3f );
        domain2.y       = (lEye.y + rEye.y) / 2 - ToInt( eyeDistance/12.0f );
        domain2.width   = ToInt(  (faceRect.x+faceRect.width-rEye.x)*0.7f );
        domain2.height  = ToInt( eyeDistance/5.0f );


        int left  = FindFaceBorder(inputImage, domain1, false);
        int right = FindFaceBorder(inputImage, domain2, true);

        facePixels = abs(right-left);
        //cvCircle(inputImage, cvPoint(left, lEye.y), 3, CV_RGB(0,255,0), 3 );
        //cvCircle(inputImage, cvPoint(right, rEye.y), 3, CV_RGB(0,255,0), 3 );

        return true;
    }


    bool RtBioRuler::DetectNose(IplImage* inputImage, const CvRect& faceRect, CvRect& noseRect)
    {
        bool bRet = false;

        cvSetImageROI(
            inputImage,
            cvRect(
            faceRect.x + int(faceRect.width  * m_noseFocusDomain.xOffset),
            faceRect.y + int(faceRect.height * m_noseFocusDomain.yOffset),
            int(faceRect.width  * m_noseFocusDomain.xRange),
            int(faceRect.height * m_noseFocusDomain.yRange)
            )
            );

        cvClearMemStorage(m_noseStorageMemory);
        CvSeq *noses = cvHaarDetectObjects(
            inputImage, 
            m_noseCascadeClassifier, 
            m_noseStorageMemory, 
            1.05, 3, 0, 
            cvSize( int(faceRect.width * m_noseFocusDomain.xMinLength), int(faceRect.height * m_noseFocusDomain.yMinLength) ),
            cvSize( int(faceRect.width * m_noseFocusDomain.xMaxLength), int(faceRect.height * m_noseFocusDomain.yMaxLength) )
            );

        if (noses && noses->total > 0)
        {
            float minDiff       = 1e30;

            for (int nose_idx = 0; nose_idx < noses->total; ++nose_idx)
            {
                CvRect *nose    = (CvRect*)cvGetSeqElem(noses, nose_idx);
                float xLength   = float(nose->width ) / float(faceRect.width );
                float yLength   = float(nose->height) / float(faceRect.height);
                float xCenter   = m_noseFocusDomain.xOffset + xLength *0.5f + float(nose->x) / float(faceRect.width );
                float yCenter   = m_noseFocusDomain.yOffset + yLength *0.5f + float(nose->y) / float(faceRect.height);
                float diff      = (xLength - m_noseFocusDomain.xAvgLength) * (xLength - m_noseFocusDomain.xAvgLength)
                                + (yLength - m_noseFocusDomain.yAvgLength) * (yLength - m_noseFocusDomain.yAvgLength)
                                + (xCenter - m_noseFocusDomain.xAvgCenter) * (xCenter - m_noseFocusDomain.xAvgCenter)
                                + (yCenter - m_noseFocusDomain.yAvgCenter) * (yCenter - m_noseFocusDomain.yAvgCenter);
                if (diff < minDiff)
                {
                    bRet       = true;
                    minDiff     = diff;
                    noseRect    = *nose;
                    noseRect.x += faceRect.x + int(faceRect.width  * m_noseFocusDomain.xOffset);    //absolute x offset of nose in the inputImage image
                    noseRect.y += faceRect.y + int(faceRect.height * m_noseFocusDomain.yOffset);    //absolute y offset of nose in the inputImage image
                }
            }
        }
        cvResetImageROI( inputImage );
        return bRet;
    }

    bool RtBioRuler::DetectEyes(IplImage* inputImage, const CvRect& faceRect, const CvRect& noseRect, CvPoint& lEye, CvPoint& rEye)
    {
        bool bRet = false;

        int noseCenterX     = noseRect.x + noseRect.width /2;
        int noseCenterY     = noseRect.y + noseRect.height/2;
        int eyeRange        = noseRect.width >= noseRect.height ? noseRect.width : noseRect.height;

        // calc left/right eye focus domain
        CvRect lFocusRect, rFocusRect;
        lFocusRect.x        = noseCenterX - int(eyeRange * 1.2f);
        lFocusRect.y        = noseCenterY - int(eyeRange * 1.4f);
        lFocusRect.width    = eyeRange * 1.2f;
        lFocusRect.height   = eyeRange * 1.2f;
        rFocusRect          = lFocusRect;
        rFocusRect.x        = noseCenterX;

        vector<CvRect> lEyes, rEyes;
        bRet = DetectEye( inputImage, lFocusRect, lEyes );
        if (!bRet)
        {
            return false;
        }

        bRet = DetectEye( inputImage, rFocusRect, rEyes );
        if (!bRet)
        {
            return false;
        }

        FindEyeHoles(inputImage, faceRect, noseRect, lEyes, rEyes, lEye, rEye);

        /*
        {
            CvRect domain1, domain2;
            domain1.x       = noseCenterX - int(eyeRange * 0.9f);
            domain1.y       = noseCenterY - int(eyeRange * 1.4f);
            domain1.width   = eyeRange * 0.6f;
            domain1.height  = eyeRange * 1.2f;
            domain2         = domain1;
            domain2.x       = noseCenterX + int(eyeRange * 0.3f);

            cvRectangle(
                inputImage,
                cvPoint(domain1.x, domain1.y),
                cvPoint(domain1.x + domain1.width, domain1.y + domain1.height),
                CV_RGB(0, 255, 255),
                2, 8, 0
                );

            cvRectangle(
                inputImage,
                cvPoint(domain2.x, domain2.y),
                cvPoint(domain2.x + domain2.width, domain2.y + domain2.height),
                CV_RGB(255, 0, 255),
                2, 8, 0
                );
        }

        {
            cvRectangle(
                inputImage,
                cvPoint(lFocusRect.x, lFocusRect.y),
                cvPoint(lFocusRect.x + lFocusRect.width, lFocusRect.y + lFocusRect.height),
                CV_RGB(0, 255, 255),
                2, 8, 0
                );

            cvRectangle(
                inputImage,
                cvPoint(rFocusRect.x, rFocusRect.y),
                cvPoint(rFocusRect.x + rFocusRect.width, rFocusRect.y + rFocusRect.height),
                CV_RGB(255, 0, 255),
                2, 8, 0
                );

            for (size_t i = 0; i < lEyes.size(); ++i)
            {
                CvRect& eye = lEyes[i];
                cvRectangle(
                    inputImage,
                    cvPoint(eye.x, eye.y),
                    cvPoint(eye.x + eye.width, eye.y + eye.height),
                    CV_RGB(255, 0, 0),
                    1, 8, 0
                    );
            }

            for (size_t i = 0; i < rEyes.size(); ++i)
            {
                CvRect& eye = rEyes[i];
                cvRectangle(
                    inputImage,
                    cvPoint(eye.x, eye.y),
                    cvPoint(eye.x + eye.width, eye.y + eye.height),
                    CV_RGB(0, 0, 255),
                    1, 8, 0
                    );
            }
        }
        //*/

        return bRet;
    }

    bool RtBioRuler::DetectEye(IplImage* inputImage, const CvRect& focusRect, vector<CvRect>& eyes)
    {
        cvSetImageROI( inputImage, focusRect );

        int threshold   = focusRect.width < focusRect.height ? focusRect.width : focusRect.height;
        int minWidth    = ToInt( float(threshold) / 2.5f );
        int minHeight   = ToInt( float(threshold) / 4.0f );
        
        cvClearMemStorage(m_eyesStorageMemory);
        CvSeq *eyes_0 = cvHaarDetectObjects(
            inputImage,
            m_eyeCascadeClassifier0, 
            m_eyesStorageMemory, 
            1.1, 15, 0,
            cvSize(minWidth, minWidth)
            );

        if (eyes_0 && eyes_0->total > 0)
        {
            for (int eye_idx = 0; eye_idx < eyes_0->total; ++eye_idx)
            {
                CvRect eye  = *(CvRect*)cvGetSeqElem(eyes_0, eye_idx);
                eye.x      += focusRect.x;
                eye.y      += focusRect.y;
                eyes.push_back( eye );
            }
        }

        //*
        cvClearMemStorage(m_eyesStorageMemory);
        CvSeq *eyes_1 = cvHaarDetectObjects(
            inputImage,
            m_eyeCascadeClassifier1, 
            m_eyesStorageMemory, 
            1.1, 10, 0,
            cvSize(minWidth, minHeight)
            );

        if (eyes_1 && eyes_1->total > 0)
        {
            for (int eye_idx = 0; eye_idx < eyes_1->total; ++eye_idx)
            {
                CvRect eye  = *(CvRect*)cvGetSeqElem(eyes_1, eye_idx);
                eye.x      += focusRect.x;
                eye.y      += focusRect.y;
                eyes.push_back( eye );
            }
        }

        cvClearMemStorage(m_eyesStorageMemory);
        CvSeq *eyes_2 = cvHaarDetectObjects(
            inputImage,
            m_eyeCascadeClassifier2,
            m_eyesStorageMemory,
            1.1, 10, 0,
            cvSize(minWidth, minHeight)
            );

        if (eyes_2 && eyes_2->total > 0)
        {
            for (int eye_idx = 0; eye_idx < eyes_2->total; ++eye_idx)
            {
                CvRect eye  = *(CvRect*)cvGetSeqElem(eyes_2, eye_idx);
                eye.x      += focusRect.x;
                eye.y      += focusRect.y;
                eyes.push_back( eye );
            }
        }
        //*/
        cvResetImageROI( inputImage );

        return eyes.size() > 0;
    }

    bool RtBioRuler::FindEyeHoles(IplImage* inputImage, const CvRect& faceRect, const CvRect& noseRect, const vector<CvRect>& lEyes, const vector<CvRect>& rEyes, CvPoint& lEye, CvPoint& rEye)
    {
        bool bRet = false;
        // from sample data
        const float cN2E   = 0.308f;
        const float cE2E   = 0.198f;

        CvPoint np = GetCenter( noseRect );

        vector<CvPoint> cs1, cs2;
        vector<float>   ws1, ws2;
        
        Analyse(lEyes, cs1, ws1);
        Analyse(rEyes, cs2, ws2);

        float min = 1e30, d1, d2, d3, w1, w2, tmp;
        for (size_t i = 0; i < cs1.size(); ++i)
        {
            CvPoint& c1     = cs1[i];
            w1     = ws1[i];
            d1     = Distance( c1, np ) / faceRect.width;
            for (size_t j = 0; j < cs2.size(); ++j)
            {
                CvPoint& c2 = cs2[j];
                w2 = ws2[j];
                d2 = Distance( c2, np ) / faceRect.width;
                d3 = Distance( c1, c2 ) / faceRect.width / 2;

                tmp = ( fabs(d1-cN2E)/w1 + fabs(d2-cN2E)/w2 + fabs(d3-cE2E)/sqrt(w1*w2) ) * ( fabs(d1-d2) + 0.1f );
                if (tmp < min)
                {
                    lEye = c1;
                    rEye = c2;
                    min  = tmp;
                    bRet = true;
                }
            }
        }
        /*
        d1 = Distance( lEye, np   ) / faceRect.width;
        d2 = Distance( rEye, np   ) / faceRect.width;
        d3 = Distance( rEye, lEye ) / faceRect.width;

        cvCircle(inputImage, lEye, 5, CV_RGB(255,0,0), 3);
        cvCircle(inputImage, rEye, 5, CV_RGB(0,0,255), 3);
        cvCircle(inputImage, np, 5, CV_RGB(0,255,0), 3);
        //*/
        return bRet;
    }


    /*

    bool RtBioRuler::FindEyeCorners(IplImage* inputImage, const CvRect& faceRect, const CvPoint& lEye, const CvPoint& rEye, vector<CvPoint>& corners)
    {
        const int MAX_CORNERS = 8;
        CvRect domain;
        int minX = lEye.x < rEye.x ? lEye.x : rEye.x;
        int maxX = lEye.x > rEye.x ? lEye.x : rEye.x;
        int minY = lEye.y < rEye.y ? lEye.y : rEye.y;
        int maxY = lEye.y > rEye.y ? lEye.y : rEye.y;

        float distance  = Distance(lEye, rEye);
        int   eyeWidth  = ToInt(distance * 0.50f);
        int   eyeHeight = ToInt(distance * 0.33f);

        domain.x        = minX - eyeWidth/4;
        domain.y        = minY - eyeHeight/4;
        domain.width    = maxX - minX + eyeWidth/2;
        domain.height   = maxY - minY + eyeHeight/2;


        IplImage* eyeImage      = cvCreateImage( cvSize(domain.width, domain.height), inputImage->depth, inputImage->nChannels );

        //copy image
        cvSetImageROI( inputImage, domain );
        cvCopyImage( inputImage, eyeImage );
        cvResetImageROI( inputImage );

        //grayImage
        IplImage* grayImage     = cvCreateImage( cvSize(domain.width, domain.height), IPL_DEPTH_8U, 1);
        //cvSplit(eyeImage, NULL, grayImage, NULL, NULL);
        cvCvtColor( eyeImage, grayImage, CV_BGR2GRAY);
        cvSmooth(grayImage, grayImage, 2, 11);
        cvEqualizeHist(grayImage, grayImage);
        GrayImageSegment(grayImage, grayImage, 3);
        cvShowImage( BIORULER_DISPLAY1, grayImage );
        cvWaitKey(0);

        //cvCvtColor( eyeImage, grayImage, CV_BGR2GRAY);
        
        IplImage* eig_image     = cvCreateImage( cvSize(domain.width, domain.height), IPL_DEPTH_8U, 1);
        IplImage* tmp_image     = cvCreateImage( cvSize(domain.width, domain.height), IPL_DEPTH_8U, 1);

        int cornerCount = MAX_CORNERS;
        CvPoint2D32f cs[ MAX_CORNERS ]; 
        cvGoodFeaturesToTrack (grayImage, eig_image, tmp_image, cs,
            &cornerCount, 0.01, 10, 0); 

        for (int i = 0; i < cornerCount; ++i)
        {
            corners.push_back( cvPoint( ToInt(cs[i].x), ToInt(cs[i].y) ) );
        }

        cvReleaseImage(&eig_image);
        cvReleaseImage(&tmp_image);

        //cvSmooth(grayImage, grayImage, 2, 5);
        //cvEqualizeHist(grayImage, grayImage);

        /// Draw corners detected  
        for( int i = 0; i < corners.size(); i++ )
        {
            cvCircle(eyeImage, corners[i], 5, CV_RGB(255,0,0), 3);
        }

        cvReleaseImage( &grayImage );
        cvReleaseImage( &eyeImage );

        return true;
    }

    bool RtBioRuler::ValidateEye(IplImage* inputImage, const CvRect& eye)
    {
        cvSetImageROI( inputImage, eye );

        IplImage* eyeImage      = cvCreateImage( cvSize(eye.width, eye.height), inputImage->depth, inputImage->nChannels );
        cvCopyImage( inputImage, eyeImage );
        cvResetImageROI( inputImage );

        cvShowImage( BIORULER_DISPLAY1, eyeImage );
        cvWaitKey(0);

        //grayImage
        IplImage* grayImage     = cvCreateImage( cvSize(eye.width, eye.height), IPL_DEPTH_8U, 1);
        cvCvtColor( eyeImage, grayImage, CV_BGR2GRAY);

        cvSmooth(grayImage, grayImage, 2, 5);
        cvEqualizeHist(grayImage, grayImage);

        vector<float> hist1, hist2;
        hist1.resize( eye.width, 0.0f );
        hist2.resize( eye.height, 0.0 );

        for (int h = 0; h < eye.height; ++h)
        {
            for (int w = 0; w < eye.width; ++w)
            {
                CvScalar scaPixelVal = cvGet2D(grayImage, h, w);
                hist1[w] += scaPixelVal.val[0]/eye.height;
                hist2[h] += scaPixelVal.val[0]/eye.width;
            }
        }

        //Laplace
        cvLaplace( grayImage, grayImage, 5 );

        //canny edge
        //cvCanny( grayImage, grayImage, 75, 300, 3 );
        cvShowImage( BIORULER_DISPLAY1, grayImage );
        cvWaitKey(0);

        //hsv
        cvCvtColor( eyeImage, eyeImage, CV_BGR2HSV);
        cvSplit(eyeImage, grayImage, NULL, NULL, NULL);
        //cvShowImage( BIORULER_DISPLAY1, grayImage );
        //cvWaitKey(0);


        //release image
        cvReleaseImage( &grayImage );
        cvReleaseImage( &eyeImage );

        return true;
    }

    //*/
    bool RtBioRuler::DetectCard(IplImage* inputImage, const CvRect& noseRect, int eyePixels, int& cardPixels, bool& bWidthOrHeight)
    {
        bool bRet = true;

        //card search domain
        CvRect domain;
        domain.x         = noseRect.x - noseRect.width*3/4;
        domain.y         = noseRect.y + noseRect.height/2;
        domain.width     = noseRect.width  * 5/2;
        domain.height    = noseRect.height * 4;
        if (domain.x < 0)
        {
            domain.x = 0;
        }
        if (domain.x + domain.width > inputImage->width)
        {
            domain.width = inputImage->width - domain.x;
        }
        if (domain.y + domain.height > inputImage->height)
        {
            domain.height= inputImage->height - domain.y;
        }
        
        IplImage* rawImage      = cvCreateImage( cvSize(domain.width, domain.height), inputImage->depth, inputImage->nChannels );
        IplImage *grayImage     = cvCreateImage( cvSize(domain.width, domain.height), inputImage->depth, 1 );

        //copy image
        cvSetImageROI( inputImage, domain );
        cvCopyImage( inputImage, rawImage );
        cvCvtColor( inputImage, grayImage, CV_BGR2GRAY);
        cvResetImageROI( inputImage );

        //cvCvtColor( rawImage, rawImage, CV_BGR2HSV );
        //cvSplit( rawImage, NULL, NULL, grayImage, NULL);
        //cvLaplace( grayImage, grayImage, 3 );
        //cvSmooth( grayImage, grayImage, 3 );
        //cvEqualizeHist( grayImage, grayImage );
        //cvShowImage( BIORULER_DISPLAY3, grayImage  );
        
        //canny edge detect
        cvCanny( rawImage, grayImage, 100, 350, 3 );
        cv::Mat cannyImage(grayImage, true);

        cv::dilate(cannyImage, cannyImage, cv::Mat(3,3,CV_8U), cvPoint(-1,-1), 3);


        //cv::imshow("dst", cannyImage);

        vector<cv::Vec4i>   rawLines;
        HoughLinesP( cannyImage, rawLines, 1, CV_PI/180, 150, 80, 20 );

        RtLine line;
        vector<float> lengths;
        for (size_t i = 0; i < rawLines.size(); ++i)
        {  
            cv::Vec4i& v4 = rawLines[i];
            line.Init( v4[0], v4[1], v4[2], v4[3] );
            float length = line.Length();
            float ratio = length / eyePixels;
            if (ratio < 1.0f || ratio > 1.46f)
                continue;

            float pitch = line.Pitch();   //0 - 90
            if (pitch > 10)
                continue;

            lengths.push_back( length );
            cvLine(rawImage, cvPoint(v4[0], v4[1]), cvPoint(v4[2], v4[3]), CV_RGB(255, 0, 0), 1, CV_AA, 0);
        }

        float defaultLength = eyePixels / 62.0f * m_idCardSize.width;
        cardPixels = ToInt( defaultLength );
        float minDiff = 1e30, diff;
        for (size_t i = 0; i < lengths.size(); ++i)
        {
            diff = fabs( lengths[i] - defaultLength );
            if ( diff < minDiff )
            {
                minDiff = diff;
                cardPixels = ToInt( lengths[i] );
            }
        }

        float tolerance = fabs(cardPixels-defaultLength) / defaultLength;
        if (tolerance > 0.2f)
        {
            bRet = false;
            cardPixels = ToInt( defaultLength );
        }
        else if (tolerance > 0.1f)
        {
            
            cardPixels = ToInt( (defaultLength+cardPixels)/2 );
        }

        //cvShowImage( BIORULER_DISPLAY1, rawImage );
        //cvShowImage( BIORULER_DISPLAY2, grayImage  );
        //cvWaitKey(0);

        cvReleaseImage( &grayImage );
        cvReleaseImage( &rawImage );
        return bRet;
    }

}