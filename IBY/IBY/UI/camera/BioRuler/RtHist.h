#pragma once

#include "opencv/cv.h"
#include <vector>

using std::vector;

typedef std::pair<int, int> IntPair;

namespace rt
{
    class RtHist
    {
    public:
        RtHist                  ();
        ~RtHist                 ();

        void                    Init                (IplImage* grayImage, bool bWidthOrHeight);
        void                    Analyse             (int block_size);
        void                    Invert              ();
        void                    Smooth              (int block_size);
        int                     FindPeak            ();

        IntPair                 FindSplit           (int threshold, bool bFromLeftOrRight);

        IplImage*               CreateHistImage     (bool bWidthOrHeight);
        void                    DrawKeys            (IplImage* inputImage, const CvScalar& color, bool bWidthOrHeight);
    protected:
        vector<float>           m_data;
        vector<int>             m_keys;
    };
}