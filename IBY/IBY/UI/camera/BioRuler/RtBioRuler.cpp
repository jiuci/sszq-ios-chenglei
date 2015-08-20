#include "RtBioRuler.h"
#include <fstream>

#include "RtMath.h"
#include "RtHist.h"
#include "PHoughTransform.h"

#include "findEyeCenter.h"

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

extern std::string g_ImagePath;
extern std::string g_strFileName;

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
        float step      = 255.0f / ( (float)nClusters - 1 );

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
        float step      = 255.0f / ( (float)nClusters - 1 );

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
		long long s = cv::getTickCount();

	 
        m_faceCascadeClassifier         = (CvHaarClassifierCascade*)cvLoad( CASCADE_FACE_FILE,  0, 0, 0 );
        m_noseCascadeClassifier         = (CvHaarClassifierCascade*)cvLoad( CASCADE_NOSE_FILE,  0, 0, 0 );
        
	
		//m_eyeCascadeClassifier0         = (CvHaarClassifierCascade*)cvLoad( CASCADE_EYES_FILE0, 0, 0, 0 );
       // m_eyeCascadeClassifier1         = (CvHaarClassifierCascade*)cvLoad( CASCADE_EYES_FILE1, 0, 0, 0 );
       // m_eyeCascadeClassifier2         = (CvHaarClassifierCascade*)cvLoad( CASCADE_EYES_FILE2, 0, 0, 0 );

        m_faceStorageMemory             = cvCreateMemStorage(0);
      //  m_noseStorageMemory             = cvCreateMemStorage(0);
     //   m_cardStorageMemory             = cvCreateMemStorage(0);
      //  m_eyesStorageMemory             = cvCreateMemStorage(0);
      //  m_lineStorageMemory             = cvCreateMemStorage(0);

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
    /*    if (NULL != m_noseStorageMemory)
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
        }*/
     /*   if (NULL != m_lineStorageMemory)
        {
            cvReleaseMemStorage( &m_lineStorageMemory );
            m_lineStorageMemory = NULL;
        }*/
        
        cvDestroyAllWindows();
    }
	bool RtBioRuler::DetectPupilsLoc(IplImage* inputImage, CvPoint& leftEye, CvPoint& rightEye)
	{
		CvRect faceRect, noseRect;
		// CvPoint lEye, rEye;

		bool bRet = false;

		bRet = DetectFace(inputImage, faceRect, noseRect, true);

		if (!bRet)
		{
			// 再次预处理后检测，尝试
			bRet = PreProcessAndDetectFace(inputImage, faceRect, noseRect, true);
			if (!bRet)
				return false;
	
		}

		//	cvRectangle(colorCopy, cvPoint(faceRect.x, faceRect.y), cvPoint(faceRect.x + faceRect.width, faceRect.y + faceRect.height), cvScalar(233, 0, 0, 0), 3);
		//	cvNamedWindow("colorCopy2", 0);
		//	cvShowImage("colorCopy2", colorCopy);
		//	cvWaitKey(0);


		float scale = 512.0f / faceRect.width;
		faceRect = faceRect * scale;
		noseRect = noseRect * scale;

		CvSize newSize = cvSize(ToInt(inputImage->width*scale), ToInt(inputImage->height*scale));

		IplImage* rawImage = cvCreateImage(newSize, inputImage->depth, inputImage->nChannels);
		cvResize(inputImage, rawImage, CV_INTER_CUBIC);

		bRet = DetectEyes(rawImage, faceRect, noseRect, leftEye, rightEye);

		if (!bRet)
		{
			cvReleaseImage(&rawImage);
			return false;
		}
		return true;
	}
	bool RtBioRuler::DetectPupilsAndCard(IplImage* inputImage, CvRect& faceRect, CvPoint& leftEye, CvPoint& rightEye, float& fPupilDistance)
    {
	
	
        CvRect /*faceRect, */noseRect;
       // CvPoint lEye, rEye;
        bool bRet = false;
		
		bRet = DetectFace(inputImage, faceRect, noseRect, true);
		
		
 //////////////////////////////		
        if (!bRet)
        { // 人脸检测失败
		//	cvWaitKey(0);
			// 再次检测
			bRet = PreProcessAndDetectFace(inputImage, faceRect, noseRect, true);
			if (!bRet)
				return false;
        }
	//	cvRectangle(colorCopy, cvPoint(faceRect.x, faceRect.y), cvPoint(faceRect.x + faceRect.width, faceRect.y + faceRect.height), cvScalar(233, 0, 0, 0), 3);
	//	cvNamedWindow("colorCopy2", 0);
	//	cvShowImage("colorCopy2", colorCopy);
	//	cvWaitKey(0);


        float scale     = 512.0f / faceRect.width;
        faceRect        = faceRect * scale;
        noseRect        = noseRect * scale;

        CvSize newSize  = cvSize( ToInt(inputImage->width*scale), ToInt(inputImage->height*scale) );

        IplImage* rawImage   = cvCreateImage( newSize, inputImage->depth, inputImage->nChannels );
        cvResize(inputImage, rawImage, CV_INTER_CUBIC);
		
		bRet = DetectEyes(rawImage, faceRect, noseRect, leftEye, rightEye);


		if (!bRet)
        {
            cvReleaseImage( &rawImage );
            return false;
        }

		int eyePixels = ToInt(Distance(leftEye, rightEye));

        int facePixels = 0;

		DetectFaceBorder(rawImage, faceRect, leftEye, rightEye, facePixels);

        /* cvRectangle(
            rawImage,
            cvPoint(faceRect.x, faceRect.y),
            cvPoint(faceRect.x + faceRect.width, faceRect.y + faceRect.height),
            CV_RGB(0, 255, 255),
            2, 8, 0
            );
        cvRectangle(
            rawImage,
            cvPoint(noseRect.x, noseRect.y),
            cvPoint(noseRect.x + noseRect.width, noseRect.y + noseRect.height),
            CV_RGB(255, 0, 255),
            2, 8, 0
            );
        //*/
        //cvSaveImage( imagePath, rawImage );
 
        int cardPixels = 0;
        bool bWidthOrHeight = true; // 默认检测卡的长边
		bRet = DetectCard(rawImage, noseRect, eyePixels, cardPixels, bWidthOrHeight);



        if (!bRet)
        {
			cvReleaseImage(&rawImage);
            return false;
        }
        float cardSize = bWidthOrHeight ? m_idCardSize.width : m_idCardSize.height;

        m_pupillaryDistance = cardSize * float(eyePixels) / float(cardPixels);
		
		fPupilDistance = m_pupillaryDistance;

		//std::cout << m_pupillaryDistance << std::endl;
        
		m_faceWidth = cardSize * float(facePixels) / float(cardPixels);

		cvReleaseImage(&rawImage);

        return bRet;
    }

    bool RtBioRuler::Detect(IplImage* inputImage, CvPoint& lEye, CvPoint& rEye, float& faceWidth)
    {
        CvRect faceRect, noseRect;
        int cardPixels;
        bool bWidthOrHeight;

        bool bRet = true;
        bRet = DetectFace( inputImage, faceRect, noseRect );
        if (!bRet)
        {
            return false;
        }

        float scale     = 512.0f / faceRect.width;
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

        m_faceWidth = m_pupillaryDistance * float(facePixels) / float(eyePixels);
        faceWidth = m_faceWidth;

        cvReleaseImage( &rawImage );
        
        lEye = lEye / scale;
        rEye = rEye / scale;

        return bRet;
    }
	bool RtBioRuler::PreProcessAndDetectFace(IplImage* inputImage, CvRect& faceRect, CvRect& noseRect, bool bDetectNose)
	{		
		bool bRet = false;		
		//试图修正强光，仅仅用于人脸检测阶段
	//	IplImage*  grayPreImage = cvCreateImage(cvGetSize(inputImage), 8, 1);
		IplImage*  colorCopy = cvCreateImage(cvGetSize(inputImage), 8, 3);

		//cvCvtColor(inputImage, grayPreImage, CV_BGR2GRAY); // 灰度化		
		cvCopy(inputImage, colorCopy);// 复制到临时文件
		cvSmooth(colorCopy, colorCopy, CV_GAUSSIAN, 3, 3, 0, 0);    //3x3

		cv::Mat MatColorCopy(colorCopy, true);// 平滑

		int nr = MatColorCopy.rows;
		int nc = MatColorCopy.cols;
		if (MatColorCopy.isContinuous()) // 判断图像数组是否连续，如果是按一行处理，提高效率
		{
			nr = 1;
			nc = nc*MatColorCopy.rows*MatColorCopy.channels();//展开

		}
		float  intensity = 0.;
		uchar* inData = NULL;
		for (size_t row = 0; row < nr; row++)
		{
			inData = MatColorCopy.ptr<uchar>(row); // 每行
			for (size_t cols = 0; cols<nc; cols += 3) // BGR
			{				 
				intensity = *(inData + cols)*0.114 + *(inData + cols + 1)*0.587 + *(inData + cols + 2)*0.3;

				if (intensity >200)// 强光 白色卡片修正
				{
					*(inData + cols) *= 0.8;
					*(inData + cols+1) *= 0.8;
					*(inData + cols+2) *= 0.8;
				}				
					
			}
		}
			 
		//cv::imwrite("manColoor1.bmp", MatColorCopy);
		cvReleaseImage(&colorCopy);

		IplImage*  colorCopycolorCopy = &IplImage(MatColorCopy);

		int minFaceSize = (colorCopycolorCopy->width < colorCopycolorCopy->height ? colorCopycolorCopy->width : colorCopycolorCopy->height) / 3;
		minFaceSize = minFaceSize > 128 ? minFaceSize : 128;

		cvClearMemStorage(m_faceStorageMemory);
		
		CvSeq* faces = cvHaarDetectObjects(
			colorCopycolorCopy,
			m_faceCascadeClassifier,
			m_faceStorageMemory,
			1.1, 3, 0,
			cvSize(minFaceSize, minFaceSize)
			);

		for (int face_idx = 0; face_idx < faces->total; ++face_idx)
		{
			faceRect = *(CvRect*)cvGetSeqElem(faces, face_idx);

			if (bDetectNose) // 检测鼻子
			{
				bRet = DetectNose(inputImage, faceRect, noseRect);
				if (bRet)
				{
					break;
				}
			}

		}	
		colorCopycolorCopy = NULL;
		 
		return bRet;
	}
	bool RtBioRuler::DetectFace(IplImage* inputImage, CvRect& faceRect, CvRect& noseRect, bool bDetectNose )
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
			
			if (bDetectNose) // 检测鼻子
			{
				bRet = DetectNose(inputImage, faceRect, noseRect);
				if (bRet)
				{
					break;
				}
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
        int block_size = 5;

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

		cvClearMemStorage(m_faceStorageMemory);
        CvSeq *noses = cvHaarDetectObjects(
            inputImage, 
            m_noseCascadeClassifier, 
			m_faceStorageMemory,
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
	void findEyes(cv::Mat frame_gray, cv::Rect face, cv::Point &leftPupil2, cv::Point &rightPupi2)
	{
		cv::Mat faceROI = frame_gray(face);
		cv::Mat debugFace = faceROI;


		// 高斯模糊 去除噪声
		if (kSmoothFaceImage)
		{
			double sigma = kSmoothFaceFactor * face.width;
			GaussianBlur(faceROI, faceROI, cv::Size(0, 0), sigma);
		}
		//相对人脸定位眼部区域
		int eye_region_width = face.width * (kEyePercentWidth / 100.0);
		int eye_region_height = face.width * (kEyePercentHeight / 100.0);
		int eye_region_top = face.height * (kEyePercentTop / 100.0);

		cv::Rect leftEyeRegion(face.width*(kEyePercentSide / 100.0),
			eye_region_top, eye_region_width, eye_region_height);
		cv::Rect rightEyeRegion(face.width - eye_region_width - face.width*(kEyePercentSide / 100.0),
			eye_region_top, eye_region_width, eye_region_height);

		// 瞳孔坐标 相对眼部区域
		cv::Point leftPupil = findEyeCenter(faceROI, leftEyeRegion, "Left Eye");
		cv::Point rightPupil = findEyeCenter(faceROI, rightEyeRegion, "Right Eye");

		// 
		/*cv::Rect leftRightCornerRegion(leftEyeRegion);
		leftRightCornerRegion.width -= leftPupil.x;
		leftRightCornerRegion.x += leftPupil.x;
		leftRightCornerRegion.height /= 2;
		leftRightCornerRegion.y += leftRightCornerRegion.height / 2;

		cv::Rect leftLeftCornerRegion(leftEyeRegion);
		leftLeftCornerRegion.width = leftPupil.x;
		leftLeftCornerRegion.height /= 2;
		leftLeftCornerRegion.y += leftLeftCornerRegion.height / 2;
		cv::Rect rightLeftCornerRegion(rightEyeRegion);

		rightLeftCornerRegion.width = rightPupil.x;
		rightLeftCornerRegion.height /= 2;
		rightLeftCornerRegion.y += rightLeftCornerRegion.height / 2;
		cv::Rect rightRightCornerRegion(rightEyeRegion);
		rightRightCornerRegion.width -= rightPupil.x;
		rightRightCornerRegion.x += rightPupil.x;
		rightRightCornerRegion.height /= 2;
		rightRightCornerRegion.y += rightRightCornerRegion.height / 2;
		rectangle(debugFace, leftRightCornerRegion, 200);
		rectangle(debugFace, leftLeftCornerRegion, 200);
		rectangle(debugFace, rightLeftCornerRegion, 200);
		rectangle(debugFace, rightRightCornerRegion, 200);*/

		// 坐标变换到全局
		rightPupil.x += rightEyeRegion.x;
		rightPupil.y += rightEyeRegion.y;
		leftPupil.x += leftEyeRegion.x;
		leftPupil.y += leftEyeRegion.y;
		// 绘制瞳孔位置
	//	circle(debugFace, rightPupil, 3, 1234);
	//	circle(debugFace, leftPupil, 3, 1234);

		leftPupil2 = leftPupil;
		rightPupi2 = rightPupil;


		//imshow("find eyes", debugFace); // 不再另外显示 knife
		//cvWaitKey(0);

		//  cv::Rect roi( cv::Point( 0, 0 ), faceROI.size());
		//  cv::Mat destinationROI = debugImage( roi );
		//  faceROI.copyTo( destinationROI );
	}
    bool RtBioRuler::DetectEyes(IplImage* inputImage, const CvRect& faceRect, const CvRect& noseRect, CvPoint& lEye, CvPoint& rEye)
    {

		std::vector<cv::Mat> rgbChannels(3);
		cv::split(inputImage, rgbChannels);

		cv::Mat frame_gray = rgbChannels[2];// 其中一个通道 B
		cv::Point leftPupil2,  rightPupi2; // todo cvpoint
		// 继续寻找瞳孔
		findEyes(frame_gray, faceRect, leftPupil2, rightPupi2);

		lEye.x = leftPupil2.x + faceRect.x;
		lEye.y = leftPupil2.y + faceRect.y;

		rEye.x = rightPupi2.x + faceRect.x;
		rEye.y = rightPupi2.y + faceRect.y;

	 
		return true;

  //      bool bRet = false;

  //      int noseCenterX     = noseRect.x + noseRect.width /2;
  //      int noseCenterY     = noseRect.y + noseRect.height/2;
  //      int eyeRange        = noseRect.width >= noseRect.height ? noseRect.width : noseRect.height;

  //      // calc left/right eye focus domain
  //      CvRect lFocusRect, rFocusRect;
  //      lFocusRect.x        = noseCenterX - int(eyeRange * 1.2f);
  //      lFocusRect.y        = noseCenterY - int(eyeRange * 1.4f);
  //      lFocusRect.width    = eyeRange * 1.2f;
  //      lFocusRect.height   = eyeRange * 1.2f;
  //      rFocusRect          = lFocusRect;
  //      rFocusRect.x        = noseCenterX;

  //      vector<CvRect> lEyes, rEyes;
  //      bRet = DetectEye( inputImage, lFocusRect, lEyes );
  //      if (!bRet)
  //      {
  //          return false;
  //      }

  //      bRet = DetectEye( inputImage, rFocusRect, rEyes );
  //      if (!bRet)
  //      {
  //          return false;
  //      }

  //      FindEyeHoles(inputImage, faceRect, noseRect, lEyes, rEyes, lEye, rEye);
		//
		//cvCircle(inputImage, lEye, 2, CV_RGB(255, 0, 0), 2);
		//cvCircle(inputImage, rEye, 2, CV_RGB(255, 0, 0), 2);
		//

		//cvNamedWindow("1212", 1);
		//cvShowImage("1212", inputImage);
 

		//cvWaitKey(0);
  //      return bRet;
    }

    bool RtBioRuler::DetectEye(IplImage* inputImage, const CvRect& focusRect, vector<CvRect>& eyes)
    {
        cvSetImageROI( inputImage, focusRect );

        int threshold   = focusRect.width < focusRect.height ? focusRect.width : focusRect.height;
        int minWidth    = ToInt( float(threshold) / 2.5f );
        int minHeight   = ToInt( float(threshold) / 4.0f );
        
		cvClearMemStorage(m_faceStorageMemory);
        CvSeq *eyes_0 = cvHaarDetectObjects(
            inputImage,
            m_eyeCascadeClassifier0, 
			m_faceStorageMemory,
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
		cvClearMemStorage(m_faceStorageMemory);
        CvSeq *eyes_1 = cvHaarDetectObjects(
            inputImage,
            m_eyeCascadeClassifier1, 
			m_faceStorageMemory,
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

		cvClearMemStorage(m_faceStorageMemory);
        CvSeq *eyes_2 = cvHaarDetectObjects(
            inputImage,
            m_eyeCascadeClassifier2,
			m_faceStorageMemory,
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

	}
    //*/

// 计算直线或线段延长线交点

CvPoint RtBioRuler::GetLinesCrossPoint(const Myline line1, const Myline line2)
{
	if (abs(line1.theta - line2.theta) < Parallel_Error)
	{
		return cvPoint(-10000, -10000);// 平行返回
	}
	CvPoint pt11 = line1.ptStart;
	CvPoint pt12 = line1.ptEnd;

	if (pt12.x == pt11.x)
	{


		CvPoint pt21 = line2.ptStart;
		CvPoint pt22 = line2.ptEnd;

		float k2 = (float)(pt22.y - pt21.y) / (pt22.x - pt21.x);
		float b2 = pt22.y - k2*pt22.x;

		int x = pt12.x;
		int y = round(k2*x + b2);
		return cvPoint(x, y);

	}
	float k1 = (float)(pt12.y - pt11.y) / (pt12.x - pt11.x);
	float b1 = pt12.y - k1*pt12.x;

	CvPoint pt21 = line2.ptStart;
	CvPoint pt22 = line2.ptEnd;

	if (pt22.x == pt21.x)
	{
		int x = pt22.x;
		int y = round(k1*x + b1);
		return cvPoint(x, y);
	}

	float k2 = (float)(pt22.y - pt21.y) / (pt22.x - pt21.x);
	float b2 = pt22.y - k2*pt22.x;

	int x = round((b2 - b1) / (k1 - k2));// (d - b) / (a - c);
	int y = round(k1*x + b1);
	return cvPoint(x, y);
}
float RtBioRuler::caclDistLines(const Myline* line1, const Myline* line2)
{
	// todo
	if (NULL == line1 || NULL == line2)
		return -10000;

}
float RtBioRuler::caclAng(const Myline* line)
{
	if (NULL == line)
			return -1;

	CvPoint pt1 = line->ptStart;
	CvPoint pt2 = line->ptEnd;
	if (pt1.x == pt2.x)
	{
		return _PI_ / 2;

	}
	return  atan((float)(pt2.y - pt1.y) / (float)(pt2.x - pt1.x));

}
//		POINT pLT, POINT pLB, POINT pRB, POINT pRT, 四边形的四个点
double RtBioRuler::PtInAnyRect(const CvPoint pCur, CvArr* contour)
{
	//CvArr* contour;
	//contour = cvCreateMat(1, 4, CV_32FC2);
	////任意四边形有4个顶点

	//for (int i = 0; i < 4; i++)
	//{
	//	 
	//	CvScalar vertex = cvScalar(RectPoints[i].x, RectPoints[i].y);       // 一个二维顶点
	//		cvSet1D(contour, i, vertex);                // 使用CvScalar作为数组元素
	//}
	CvPoint2D32f pt;
	pt.x = pCur.x;
	pt.y = pCur.y;
	double val = cvPointPolygonTest(contour, pt, 1); // 1 -1 0  内 上 外
	
	return val;
}
float RtBioRuler::SegmentError(IplImage* gray, const CvPoint ptLeftTop, const CvPoint ptLefttBottom, const CvPoint  ptRightTop, const CvPoint ptRightBottom)
{
	// 沿着直线搜索边缘信息 
	float result = 0; //  边缘统计
	int countPts = 0;  // 边缘长度

	int ImgWidth =   gray->width;
	// 一定注意对齐操作
	if (ImgWidth % 4 != 0)
		ImgWidth = 4 * (ImgWidth / 4+1);
	//const int ImgHeight = gray->height;

	uchar* data = (uchar*)gray->imageData;

	int	innerValue = 0;	
	 // 上
	float fkTop = float(ptRightTop.y - ptLeftTop.y) / float(ptRightTop.x - ptLeftTop.x);
	
	for (int j = ptLeftTop.x; j < ptRightTop.x; j++)
	{	
			int i = ptLeftTop.y + (j - ptLeftTop.x) *fkTop;
			
			innerValue = data[i * ImgWidth + j];
			if (innerValue >100)
			{
				result++; // 边缘统计
			}
			else if (data[(i - 1) * ImgWidth + j] >100)
			{
				result++; // 边缘统计
			}
			else if (data[(i + 1) * ImgWidth + j] >100)
			{
				result++; // 边缘统计
			}

		 
	}
	countPts += ptRightTop.x - ptLeftTop.x;

	float fkBottom = float(ptRightBottom.y - ptLefttBottom.y) / float(ptRightBottom.x - ptLefttBottom.x);
	// 下
	for (int j = ptLefttBottom.x; j < ptRightBottom.x; j++)
	{
			int  i = ptLefttBottom.y + (j - ptLefttBottom.x) * fkBottom;
			innerValue = data[i * ImgWidth + j];
		 
			if (innerValue >100)
			{
				result++; // 边缘统计
			}
			else if (data[(i - 1) * ImgWidth + j] >100)
			{
				result++; // 边缘统计
			}
			else if (data[(i + 1) * ImgWidth + j] >100)
			{
				result++; // 边缘统计
			}		
	}
	countPts += ptRightBottom.x - ptLefttBottom.x;
	// 左
	float fkleft = float(ptLefttBottom.x - ptLeftTop.x) / float(ptLefttBottom.y - ptLeftTop.y);
	for (int j = ptLeftTop.y; j < ptLefttBottom.y; j++)
	{	 
		int i = ptLeftTop.x + (j - ptLeftTop.y) *fkleft;
		innerValue = data[j * ImgWidth + i];
		if (innerValue >100)
		{
			result++; // 边缘统计
		}
		else if (data[j * ImgWidth + i - 1] >100)
		{
			result++; // 边缘统计
		}
		else if (data[j * ImgWidth + i + 1] >100)
		{
			result++; // 边缘统计
		} 
		
	}
	countPts += ptLefttBottom.y - ptLeftTop.y;
	// 右
	float fkright = float(ptRightBottom.x - ptRightTop.x) / float(ptRightBottom.y - ptRightTop.y);
	for (int j = ptRightTop.y; j < ptRightBottom.y; j++)
	{
		int i = ptRightTop.x + (j - ptRightTop.y) *fkright;
		innerValue = data[j * ImgWidth + i];
		if (innerValue>100)
		{
			result++; // 边缘统计
		}
		else if (data[j * ImgWidth + i - 1] >100)
		{
			result++; // 边缘统计
		}
		else if (data[j * ImgWidth + i +1] >100)
		{
			result++; // 边缘统计
		}
		
	}
	countPts += ptRightBottom.y - ptRightTop.y;

#ifdef _DEBUG
	printf("result - %f ,countPts - %d \n", result, countPts);
#endif
	return  result/ countPts;

}
bool RtBioRuler::PtInStdRect(const CvPoint& pt, const CvRect &rect)
{
	if (pt.x <= 3 || pt.y <= 3)
		return false;
	if (pt.x > rect.width-3 || pt.y >rect.height-3)
		return false;
	return true;
}

bool RtBioRuler::test4Lines(const Myline line1, const Myline line2, const Myline line3, const Myline line4, float &distDiag, IplImage* color_dst, float& fCardPiexls)
{
	Myline orderLine1, orderLine2, orderLine3, orderLine4;

	if (line1.ptStart.y >line2.ptStart.y)// 确定水平线的上下水 关系
	{
		orderLine1 = line2;
		orderLine2 = line1;
	}
	else
	{
		orderLine1 = line1;
		orderLine2 = line2;
	}

	if (line3.ptStart.x >line4.ptStart.x)//  确定垂直线的左右关系
	{
		orderLine3 = line4;
		orderLine4 = line3;
	}
	else
	{
		orderLine3 = line3;
		orderLine4 = line4;
	}

	float fMinAng = 82* _PI_ / 180;
	float fMaxAng = 98 * _PI_ / 180;
	//  夹角判断
	 
		float ang = abs(line1.theta - line3.theta);
		if (ang < fMinAng || ang > fMaxAng)
		{
			return false;
		}
 
		 ang = abs(line1.theta - line4.theta);
		if (ang < fMinAng || ang > fMaxAng)
		{
			return false;
		}
		 ang = abs(line2.theta - line3.theta);
		if (ang < fMinAng || ang > fMaxAng)
		{
			return false;

		}
	 
		 ang = abs(line2.theta - line4.theta);
		if (ang < fMinAng || ang > fMaxAng)
		{
			return false;
		}
		
		CvPoint ptLeftTop = GetLinesCrossPoint(orderLine1, orderLine3);
		CvPoint ptRightBottom = GetLinesCrossPoint(orderLine2, orderLine4);

		CvPoint ptLefttBottom = GetLinesCrossPoint(orderLine2, orderLine3);
		CvPoint ptRightTop = GetLinesCrossPoint(orderLine1, orderLine4);

		// 排除 焦点超出范围的 点 
		{
			if (!PtInStdRect(ptLeftTop, m_CardRect))
				return false;
			if (!PtInStdRect(ptRightBottom, m_CardRect))
				return false;
			if (!PtInStdRect(ptLefttBottom, m_CardRect))
				return false;
			if (!PtInStdRect(ptRightTop, m_CardRect))
				return false;
		}
		// 轮廓验证 如果整条线都不在矩形内，那就...
		{
			CvArr* contour;
			contour = cvCreateMat(1, 4, CV_32FC2);
			//任意四边形有4个顶点
			int nCount = 4;
			const CvPoint RectPoints[4] = { ptLeftTop, ptLefttBottom, ptRightBottom,ptRightTop  };
			//const CvPoint RectPoints[4] = { cvPoint(10, 10), cvPoint(10, 50), cvPoint(50, 50), cvPoint(50, 10) };
			for (int i = 0; i < 4; i++)
			{

				CvScalar vertex = cvScalar(RectPoints[i].x, RectPoints[i].y);       // 一个二维顶点
				cvSet1D(contour, i, vertex);                // 使用CvScalar作为数组元素
			}		 
			//const int WidEr = 0.05 * m_CardRect.width;
			if ((PtInAnyRect(orderLine1.ptStart, contour) <-10 || PtInAnyRect(orderLine1.ptEnd, contour) <-10)) // > -1 防止斜边计算到直线意外
				return false;
			if ((PtInAnyRect(orderLine2.ptStart, contour) <-10 || PtInAnyRect(orderLine2.ptEnd, contour)<-10))
				return false;
			if ((PtInAnyRect(orderLine3.ptStart, contour) <-10 || PtInAnyRect(orderLine3.ptEnd, contour)<-10))
				return false;
			if ((PtInAnyRect(orderLine4.ptStart, contour) <-10 || PtInAnyRect(orderLine4.ptEnd, contour)<-10))
				return false;
		}
		int detaX = sqrt((ptRightTop.x - ptLeftTop.x)*(ptRightTop.x - ptLeftTop.x) + 
			(ptRightTop.y - ptLeftTop.y)*(ptRightTop.y - ptLeftTop.y));
		int detaY = sqrt((ptLefttBottom.x - ptLeftTop.x)*(ptLefttBottom.x - ptLeftTop.x) + 
			(ptLefttBottom.y - ptLeftTop.y)*(ptLefttBottom.y - ptLeftTop.y));

		int detaX1 = sqrt((ptRightBottom.x - ptLefttBottom.x)*(ptRightBottom.x - ptLefttBottom.x) + 
			(ptRightBottom.y - ptLefttBottom.y)*(ptRightBottom.y - ptLefttBottom.y));
		int detaY1 = sqrt((ptRightBottom.x - ptRightTop.x)*(ptRightBottom.x - ptRightTop.x) +
			(ptRightBottom.y - ptRightTop.y)*(ptRightBottom.y - ptRightTop.y));

		//  鼻子区域比较
		if (abs(detaX) < m_NoseRect.width  || abs(detaY)<m_NoseRect.height )
		{
			return false;
		}
		if (abs(detaX) > m_NoseRect.width * 3 || abs(detaY)>m_NoseRect.height * 2)
		{
			return false;
		}
		if (abs(detaX1) < m_NoseRect.width  || abs(detaY1)<m_NoseRect.height)
		{
			return false;
		}
		if (abs(detaX1) > m_NoseRect.width *3 || abs(detaY1)>m_NoseRect.height * 2)
		{
			return false;
		}
		
		float ratio = (float)(detaX) / (float)(detaY);
		float fRatioError = abs((abs(ratio) - HV_RATIO));	

		
		// 误差允许范围
		if (fRatioError < HV_RATIO_ERROR)
		{
#ifdef _DEBUG
			printf("符合条件的ratio差:%f\n", abs((abs(ratio) - HV_RATIO)));
#endif
			float Error = SegmentError(color_dst, ptLeftTop, ptLefttBottom, ptRightTop, ptRightBottom);
#ifdef _DEBUG
		printf("类间方差:%f\n", Error);
#endif
			if (Error > distDiag)
			{
				distDiag = Error;// +(1 - fRatioError);
			}
			// card length
			float ftopLen = sqrt((ptRightTop.x - ptLeftTop.x)*(ptRightTop.x - ptLeftTop.x) + (ptRightTop.y - ptLeftTop.y)*(ptRightTop.y - ptLeftTop.y));
			float fBotLen = sqrt((ptRightBottom.x - ptLefttBottom.x)*(ptRightBottom.x - ptLefttBottom.x) + (ptRightBottom.y - ptLefttBottom.y)*(ptRightBottom.y - ptLefttBottom.y));
			fCardPiexls = ( ftopLen + fBotLen) / 2;
#ifdef _DEBUG
			printf("综合权重 :%f\n", distDiag);
#endif
			return true;
		}
		else
			return false;
		
 
}
    bool RtBioRuler::DetectCard(IplImage* inputImage, const CvRect& noseRect, int eyePixels, int& cardPixels, bool& bWidthOrHeight)
    {
        bool bRet = false;		

        //card search domain
        CvRect domain;
		domain.x = noseRect.x - noseRect.width;// *3 / 4;
		domain.y = noseRect.y + 1.2*noseRect.height;// *3 / 4;//
		domain.width = noseRect.width * 3;// 10 / 4;// 5 / 2;
        domain.height    = noseRect.height*3;// 3 对于放在下巴之上足够了  4
		// add 20150603
		m_NoseRect = noseRect;
		m_CardRect = domain;

#ifdef _DEBUG
		cvNamedWindow("card_img", 1);
		cvShowImage("card_img", inputImage);
#endif
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
        IplImage* grayImage     = cvCreateImage( cvSize(domain.width, domain.height), inputImage->depth, 1 );
	 
        //copy image
        cvSetImageROI( inputImage, domain );
        cvCopyImage( inputImage, rawImage );
		cvCvtColor(inputImage, grayImage, CV_BGR2GRAY); 
		
	 
		cvResetImageROI( inputImage );

		cvSmooth(rawImage, rawImage, CV_GAUSSIAN,5,5, 0, 0);    //平滑处理 尽量多的检测边缘
        //canny edge detect
        cvCanny( rawImage, grayImage, 90, 30, 3 ); // 120 30 	

		cv::Mat cannyImage(grayImage, true);		
		vector<cv::Vec4i>   rawLines;
		int minPiexls = noseRect.width / 15;
		int minLineLength = noseRect.width / 7;
		int minLineGap = noseRect.width / 35;

		CvMat c_image = cannyImage;
		MyHoughLinesProbabilistic(&c_image, 1, CV_PI / 90, minPiexls, minLineLength, minLineGap, rawLines);
	//////////////////////////////////////////////////////////

		RtLine line;
	//	IplImage* rawImageCopy = cvCreateImage(cvSize(domain.width, domain.height), inputImage->depth, inputImage->nChannels);
	//	cvCopyImage(rawImage, rawImageCopy);	

		vecMyLines Hlines; // 水平线
		vecMyLines Vlines; // 垂直线

        vector<float> lengths;
        for (size_t i = 0; i < rawLines.size(); ++i)// 直线筛选
        {  
            cv::Vec4i& v4 = rawLines[i];
            line.Init( v4[0], v4[1], v4[2], v4[3] );    

			Myline  lineTemp;
			lineTemp.ptStart = cvPoint(v4[0], v4[1]);
			lineTemp.ptEnd   = cvPoint(v4[2], v4[3]);
			// 求角度
			float fAng = caclAng(&lineTemp);
			const int iBoderEr = 5;
			if (abs(fAng) < _PI_ / 18)  // 水平线
			{
				if (lineTemp.ptStart.x > lineTemp.ptEnd.x) // 交换
				{
					lineTemp.ptStart = cvPoint(v4[2], v4[3]);
					lineTemp.ptEnd =  cvPoint(v4[0], v4[1]);
				}

				if (lineTemp.ptStart.x <= iBoderEr || lineTemp.ptStart.y <= iBoderEr)
					continue;
				if (lineTemp.ptEnd.x >= (domain.width - iBoderEr) || lineTemp.ptEnd.y >= (domain.height - iBoderEr))
					continue;
				lineTemp.theta = fAng;
				Hlines.push_back(lineTemp);

				//cvLine(rawImageCopy, lineTemp.ptStart, lineTemp.ptEnd, CV_RGB( 255,0, 0), 1, CV_AA, 0);
				 
			}
			if (abs(fAng) > _PI_ * 8 / 18)// 垂直线
			{
				if (lineTemp.ptStart.y> lineTemp.ptEnd.y) // 交换
				{
					lineTemp.ptStart = cvPoint(v4[2], v4[3]);
					lineTemp.ptEnd = cvPoint(v4[0], v4[1]);
				}

				if (lineTemp.ptStart.x <= iBoderEr || lineTemp.ptStart.y <= iBoderEr)
					continue;
				if (lineTemp.ptEnd.x >= (domain.width - iBoderEr) || lineTemp.ptEnd.y >= (domain.height - iBoderEr))
					continue;
				

				lineTemp.theta = fAng;
				Vlines.push_back(lineTemp);
				//cvLine(rawImageCopy, lineTemp.ptStart, lineTemp.ptEnd, CV_RGB(0, 255, 0), 1, CV_AA, 0);
			}
        }

	//	cvNamedWindow("hough", 1);
	//	cvShowImage("hough", rawImageCopy);

		// 进一步检测  是否有成对直线
		int ihlinesNum = (int)Hlines.size();
		int ivlinesNum = (int)Vlines.size();
		if (ihlinesNum < 2 || ivlinesNum < 2) //  没有成对直线
		{		 
			cvReleaseImage(&grayImage);
			cvReleaseImage(&rawImage);
			return false;
		}

		Myline fline1;
		Myline fline2;
		Myline fline3;
		Myline fline4;
		float fdistDiag = -10001.0f;

		int TheLastOne = 0;
		
		for (int i = 0; i < ivlinesNum; i++)
		{
			for (int j = i + 1; j < ivlinesNum; j++)
			{
				Myline line3 = Vlines[i]; // 垂直线
				Myline line4 = Vlines[j];

				// 首先测试平行度
				if (line3.theta *line4.theta < 0)
				{

					if (abs(_PI_ - abs(line3.theta) - abs(line4.theta)) >8* _PI_ / 180)
						continue;
				}
				else
				{
					if (abs(line3.theta - line4.theta) >6* _PI_ / 180) // 
						continue;
				}				

			//	if (line3.ptStart.x <3 || line3.ptEnd.x <3 )
				if (std::max(abs(line3.ptStart.y - line4.ptEnd.y), abs(line3.ptEnd.y - line4.ptStart.y)) > 2 * noseRect.height)
					continue;

				//与卡在场景中的尺寸比例成正比，场景尺寸由鼻子尺寸决定的 
				const float keyPar =  2.5;
				// 再次测试线段直接的距离
				//  以Y向差表示线段距离
				int distV = (abs(line3.ptStart.x - line4.ptStart.x) + abs(line3.ptEnd.x - line4.ptEnd.x) ) / 2;
				
				if (distV < 1.5*noseRect.width || distV >keyPar*noseRect.width)
					continue;

				for (int k = 0; k < ihlinesNum; k++)
				for (int g = k + 1; g < ihlinesNum; g++)
				{
					Myline line1 = Hlines[k];
					Myline line2 = Hlines[g];

					// 首先测试平行度
					if (line1.theta *line2.theta < 0)
					{

						if (abs(_PI_ - abs(line1.theta) - abs(line2.theta)) >3 * _PI_ / 180)
							continue;
					}
					else
					{
						if (abs(line1.theta - line2.theta) >3 * _PI_ / 180) // 
							continue;
					}
					

					if (std::max(abs(line1.ptStart.x - line2.ptEnd.x), abs(line1.ptEnd.x - line2.ptStart.x)) > 2 * noseRect.width)
						continue;

					// 再次测试线段直接的距离
					//  以Y向差表示线段距离
					int distH = (abs(line1.ptStart.y - line2.ptStart.y) + abs(line1.ptEnd.y - line2.ptEnd.y) ) / 2;

					// 大致比例判断 1.58 是中心
					if (1.4 *distH > distV  || distH < distV/1.7)
					{
						continue;
					}
				 	if (distH < 0.9*noseRect.height || distH > 2 * noseRect.height)
					 	continue;

					// 四条线段的散度测量
					float fMaxSandu = 0;
					float fMinSandu = 0;
					MaxDivergence4Lines(line1, line2, line3, line4, fMaxSandu, fMinSandu);
					
					if (fMaxSandu >keyPar* m_NoseRect.width)
					{
						continue;
					}
					if (fMaxSandu <  1.5*m_NoseRect.height)
					{
						continue;
					}
				 
					float distDiag = 0.0f;

					float fCardPiexls = 0;
					bool isRect = test4Lines(line1, line2, line3, line4, distDiag, grayImage, fCardPiexls);//  边缘图搜索
					
					if (isRect)
					{
						if (distDiag > fdistDiag)
						{
							fdistDiag = distDiag;

							fline1 = line1;
							fline2 = line2;
							fline3 = line3;
							fline4 = line4;		

							cardPixels = (int) fCardPiexls;

						//	TheLastOne = num22;						 
							//IplImage* temo = cvCloneImage(grayImage2);
							//cvLine(temo, line1.ptStart, line1.ptEnd, CV_RGB(255, 255, 0), 1, CV_AA, 0);
							//cvLine(temo, line2.ptStart, line2.ptEnd, CV_RGB(255, 255, 0), 1, CV_AA, 0);
							//cvLine(temo, line3.ptStart, line3.ptEnd, CV_RGB(255, 255, 0), 1, CV_AA, 0);
							//cvLine(temo, line4.ptStart, line4.ptEnd, CV_RGB(255, 255, 0), 1, CV_AA, 0);
							//static int num = 0;
							//cvSaveImage("temp.jpg", temo);
						}					
					}
				}
			}
		}
		

		if (fdistDiag < -10000) //  卡片检测失败
		{
			// 构造缺省值或误差范围
			float defaultLength = eyePixels / 70.0f * m_idCardSize.width;
			cardPixels = ToInt(defaultLength);
		}	
		
		cvReleaseImage(&grayImage);
		cvReleaseImage(&rawImage);

        return true;
    }

	float DistPoints(const CvPoint pt1, const CvPoint pt2)
	{

		return sqrt((pt1.x - pt2.x)*(pt1.x - pt2.x) + (pt1.y - pt2.y)*(pt1.y - pt2.y));
	}
	// 线段散度 计算 
	void  RtBioRuler::MaxDivergence4Lines(const Myline line1, const Myline line2, const Myline line3, const Myline line4,float & fmax,float &fmin)
	{
		CvPoint* pt = new CvPoint[8];


		pt[0] = line1.ptStart;
		pt[1] = line1.ptEnd;
		pt[2] = line2.ptStart;
		pt[3] = line2.ptEnd;

		pt[4] = line3.ptStart;
		pt[5] = line3.ptEnd;
		pt[6] = line4.ptStart;
		pt[7] = line4.ptEnd;
	 

		float fMaxT = 0;
		float fMinT = 100000;
		for (int i = 0; i < 8;i++)
		for (int j = i+1; j < 8; j++)
		{

			float dstTemp = DistPoints(pt[i], pt[j]);
			if (dstTemp > fMaxT)
			{
				fMaxT = dstTemp;
			}
			if (dstTemp < fMinT)
			{
				fMinT = dstTemp;
			}
		}
		fmax = fMaxT;
		fmin = fMinT;

		delete pt;
		return ;

	}

}

