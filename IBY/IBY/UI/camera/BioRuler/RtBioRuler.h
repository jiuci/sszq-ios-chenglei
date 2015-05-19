#pragma once

#include "opencv/cv.h"
#include "opencv/highgui.h"

using std::vector;

namespace rt
{
    class RtBioRuler
    {
    private:
        static RtBioRuler single;

    protected:

        struct NoseFocusDomain
        {
            float xOffset;
            float yOffset;
            float xRange;
            float yRange;
            float xMinLength;
            float xMaxLength;
            float yMinLength;
            float yMaxLength;
            float xAvgCenter;
            float yAvgCenter;
            float xAvgLength;
            float yAvgLength;
        };

        struct IdCardSize
        {
            float width;
            float height;
        };

    public:
        static RtBioRuler* getInstance();

        RtBioRuler                  ();
        ~RtBioRuler                 ();

        bool                        Init                        (IplImage* inputImage, float& faceWidth );

        bool                        Detect                      (IplImage* inputImage, CvPoint& lEye, CvPoint& rEye, float& faceWidth,int& facePixels);

    protected:
        bool                        DetectFace                  (IplImage* inputImage, CvRect& faceRect, CvRect& noseRect);
        bool                        DetectFaceBorder            (IplImage* inputImage,  CvRect& faceRect, const CvPoint& lEye, const CvPoint& rEye, int& facePixels);
        bool                        DetectNose                  (IplImage* inputImage, const CvRect& faceRect, CvRect& noseRect);
        bool                        DetectEyes                  (IplImage* inputImage, const CvRect& faceRect, const CvRect& noseRect, CvPoint& lEye, CvPoint& rEye);
        bool                        DetectEye                   (IplImage* inputImage, const CvRect& focusRect, vector<CvRect>& eyes);
        bool                        FindEyeHoles                (IplImage* inputImage, const CvRect& faceRect, const CvRect& noseRect, const vector<CvRect>& lEyes, const vector<CvRect>& rEyes, CvPoint& lEye, CvPoint& rEye);
        bool                        FindEyeCorners              (IplImage* inputImage, const CvRect& faceRect, const CvPoint& lEye, const CvPoint& rEye, vector<CvPoint>& corners);

        bool                        DetectCard                  (IplImage* inputImage, const CvRect& noseRect, int eyePixels, int& cardPixels, bool& bWidthOrHeight);

    protected:
        CvHaarClassifierCascade*    m_faceCascadeClassifier;
        CvHaarClassifierCascade*    m_noseCascadeClassifier;
        CvHaarClassifierCascade*    m_eyeCascadeClassifier0;
        CvHaarClassifierCascade*    m_eyeCascadeClassifier1;
        CvHaarClassifierCascade*    m_eyeCascadeClassifier2;

        CvMemStorage*               m_faceStorageMemory;
        CvMemStorage*               m_noseStorageMemory;
        CvMemStorage*               m_cardStorageMemory;
        CvMemStorage*               m_eyesStorageMemory;
        CvMemStorage*               m_lineStorageMemory;

        IdCardSize                  m_idCardSize;
        NoseFocusDomain             m_noseFocusDomain;

        IplImage*                   m_faceImageWithCard;
        IplImage*                   m_faceImage;
        float                       m_pupillaryDistance;
        float                       m_faceWidth;
    };
}