#include "RtHist.h"
#include "RtMath.h"

extern "C"{
    size_t fwrite$UNIX2003( const void *a, size_t b, size_t c, FILE *d )
    {
        return fwrite(a, b, c, d);
    }
    char* strerror$UNIX2003( int errnum )
    {
        return strerror(errnum);
    }
}

namespace rt
{

    void DouglasPeucker(const RtVec2TArray& points, float threshold, int s, int e, vector<int>& k)
    {
        float maxDistance = 0;
        int m = -1;
        for (int i = s+1; i < e-1; ++i) 
        {
            float distance = points[i].DistanceToLine( points[s], points[e] );
            if (distance >= threshold && distance > maxDistance)
            {
                maxDistance = distance;
                m = i;
            }
        }
        if (m > 0)
        {
            DouglasPeucker(points, threshold, s, m, k);
            k.push_back(m);
            DouglasPeucker(points, threshold, m, e, k);
        }
    }


    RtHist::RtHist()
    {
    }

    RtHist::~RtHist()
    {
    }

    void RtHist::Init(IplImage* grayImage, bool bWidthOrHeight)
    {
        int histWidth  = bWidthOrHeight ? grayImage->width : grayImage->height;
        int histHeight = !bWidthOrHeight ? grayImage->width : grayImage->height;
        m_data.resize( histWidth, 0.0f );
        for (int h = 0; h < grayImage->height; ++h)
        {
            for (int w = 0; w < grayImage->width; ++w)
            {
                CvScalar scaPixelVal = cvGet2D(grayImage, h, w);
                int idx = bWidthOrHeight ? w : h;
                m_data[idx] += scaPixelVal.val[0];
            }
        }

        for (int i = 0; i < histWidth; ++i)
        {
            m_data[i] /= histHeight;
        }
        m_keys.clear();
    }

    void RtHist::Analyse(int block_size)
    {
        m_keys.clear();
        int half_size = block_size/2;
        block_size = half_size*2+1;

        int num = (int)m_data.size();

        for (int i = 1; i < num-1; ++i)
        {
            float v = m_data[i];
            bool bKey = true;

            int counter = 0;

            for (int j = half_size; j > 0; --j)
            {
                int idx1 = clamp(i-j, 0, num-1);
                int idx2 = clamp(i+j, 0, num-1);
                float v1 = m_data[idx1];
                float v2 = m_data[idx2];
                float k1 = v1-v;
                float k2 = v2-v;
                if (k1 * k2 < 0)
                {
                    bKey = false;
                    break;
                }
                else if (k1 * k2  == 0)
                {
                    if (fabs(k1) >= block_size || fabs(k2) >= block_size)
                    {
                        counter = 0;
                    }
                    else
                    {
                        ++counter;
                    }
                }
            }

            if (bKey && counter < half_size)
            {
                m_keys.push_back( i );
            }
        }
    }

    void RtHist::Invert()
    {
        int num = (int)m_data.size();
        for (int i = 0; i < num; ++i)
        {
            m_data[i] = 255.0f - m_data[i];
        }
    }

    void RtHist::Smooth(int block_size)
    {
        int half_size = block_size/2;
        block_size = half_size*2 + 1;

        int num = (int)m_data.size();

        vector<float> tmp = m_data;
        for (int i = 0; i < num; ++i)
        {
            float t = 0.0;
            for (int j = -half_size; j <= half_size; ++j)
            {
                int idx = clamp(i+j, 0, num-1);
                t += tmp[ idx ];
            }
            m_data[i] = t / block_size;
        }
    }
    /*
    vector< IntPair > RtHist::FindSplits(int threshold)
    {
        int num = (int)m_data.size();
        RtVec2TArray points;

        vector< IntPair > splits;

        float avg = 0.0f, var = 0.0f;
        for (int i = 0; i < num; ++i)
        {
            float& v = m_data[i];
            avg += v;
            var += v*v;
            points.push_back( rt::RtVec2T<float>(i, v) );
        }

        //float threshold = sqrt( var/num - avg*avg/num/num );

        num = (int)m_keys.size();
        for (int i = 0; i < num-1; ++i)
        {
            int idx1 = m_keys[i];
            int idx2 = m_keys[i+1];

            float v1 = m_data[ idx1 ];
            float v2 = m_data[ idx2 ];

            if ( fabs(v1-v2) > threshold )
            {
                splits.push_back( std::make_pair(idx1, idx2) );
            }
        }

        return splits;
    }
    //*/

    int RtHist::FindPeak()
    {
        int num = (int)m_data.size();
        float maxValue = -1;
        int peak = -1;
        for (int i = 0; i < num; ++i)
        {
            if (m_data[i] > 1.0f && m_data[i] > maxValue)
            {
                maxValue = m_data[i];
                peak = i;
            }
        }
        return peak;
    }

    IntPair RtHist::FindSplit(int threshold, bool bFromLeftOrRight)
    {
        int num = (int)m_data.size();
        float threshold2 = 0.0f, maxValue = 0;
        for (int i = 0; i < num; ++i)
        {
            float& v = m_data[i];
            threshold2 += v;
            maxValue = v > maxValue ? v : maxValue;
        }
        threshold2 /= m_data.size();
        threshold2 = (maxValue + threshold2)/2;


        IntPair split(0, num-1);

        num = (int)m_keys.size();
        if (num < 1)
        {
            return split;
        }

        bool bFound = false;

        if (bFromLeftOrRight)
        {
            for (int i = 1; i < num-1; ++i)
            {
                int idx0 = m_keys[i-1];
                int idx1 = m_keys[i];
                int idx2 = m_keys[i+1];

                float v0 = m_data[ idx0 ];
                float v1 = m_data[ idx1 ];
                float v2 = m_data[ idx2 ];
                if (v1 > threshold2)
                    continue;
                if (v0 < v1)
                    continue;
                if (v2 < v1)
                    continue;

                float d1 = fabs(v1-v0);
                float d2 = fabs(v1-v2);

                if (d1 > threshold)
                {
                    bFound = true;
                    split.first = idx0;
                    split.second = idx1;
                    break;
                }
                if (d2 > threshold)
                {
                    bFound = true;
                    split.first = idx1;
                    split.second = idx2;
                    break;
                }
            }
            if (bFound)
            {
                return split;
            }
            else
            {
                split.first = 0;
                split.second = m_keys[0];
                float maxDiff = fabs( m_data[split.first] - m_data[split.second ] );

                for (int i = 0; i < num-1; ++i)
                {
                    int idx0 = m_keys[i];
                    int idx1 = m_keys[i+1];

                    float diff = fabs( m_data[ idx0 ] - m_data[ idx1 ] );

                    if (diff > maxDiff)
                    {
                        maxDiff = diff;
                        split.first = idx0;
                        split.second = idx1;
                    }
                }
                return split;
            }
        }
        else
        {
            for (int i = num-2; i > 0; --i)
            {
                int idx0 = m_keys[i+1];
                int idx1 = m_keys[i];
                int idx2 = m_keys[i-1];

                float v0 = m_data[ idx0 ];
                float v1 = m_data[ idx1 ];
                float v2 = m_data[ idx2 ];
                if (v1 > threshold2)
                    continue;
                if (v0 < v1)
                    continue;
                if (v2 < v1)
                    continue;

                float d1 = fabs(v1-v0);
                float d2 = fabs(v1-v2);

                if (d1 > threshold)
                {
                    bFound = true;
                    split.first = idx1;
                    split.second = idx0;
                    break;
                }
                if (d2 > threshold)
                {
                    bFound = true;
                    split.first = idx2;
                    split.second = idx1;
                    break;
                }
            }
            if (bFound)
            {
                return split;
            }
            else
            {
                split.first = m_keys[num-1];
                split.second = m_data.size()-1;
                float maxDiff = fabs( m_data[split.first] - m_data[split.second ] );

                for (int i = num-1; i > 0; --i)
                {
                    int idx0 = m_keys[i];
                    int idx1 = m_keys[i-1];
                    float diff = fabs( m_data[ idx0 ] - m_data[ idx1 ] );

                    if (diff > maxDiff)
                    {
                        maxDiff = diff;
                        split.first = idx1;
                        split.second = idx0;
                    }
                }
                return split;
            }
        }
    }

    IplImage* RtHist::CreateHistImage(bool bWidthOrHeight)
    {
        IplImage* histImage = NULL;
        size_t num = m_data.size();
        if (num > 0)
        {
            CvScalar white = cvScalar(255);
            CvScalar black = cvScalar(0);
            CvScalar gray  = cvScalar(128,128,128);
            if (bWidthOrHeight)
            {
                histImage = cvCreateImage( cvSize(num, 256), IPL_DEPTH_8U, 1);
                for (int w = 0; w < num; ++w)
                {
                    int hh = ToInt( m_data[w] );
                    for (int h = 0; h < hh; ++h)
                    {
                        cvSet2D(histImage, 255-h, w, white);
                    }

                    for (int h = 0; h < 255-hh; ++h)
                    {
                        cvSet2D(histImage, h, w, black);
                    }
                }
                for (size_t i = 0; i < m_keys.size(); ++i)
                {
                    cvLine(histImage, cvPoint(m_keys[i], 0), cvPoint(m_keys[i], 255), gray); 
                }
                
            }
            else
            {
                histImage = cvCreateImage( cvSize(256, num ), IPL_DEPTH_8U, 1);
                for (int h = 0; h < num; ++h)
                {
                    int ww = ToInt( m_data[h] );
                    for (int w = 0; w < ww; ++w)
                    {
                        cvSet2D(histImage, h, w, white);
                    }
                    for (int w = ww; w < 255; ++w)
                    {
                        cvSet2D(histImage, h, w, black);
                    }
                }

                for (size_t i = 0; i < m_keys.size(); ++i)
                {
                    cvLine(histImage, cvPoint(0, m_keys[i]), cvPoint(255, m_keys[i]), gray); 
                }
            }
        }
        return histImage;
    }
    
    void RtHist::DrawKeys(IplImage* inputImage, const CvScalar& color, bool bWidthOrHeight)
    {
        if (bWidthOrHeight)
        {
            if (m_data.size() != inputImage->width)
                return;
            for (size_t i = 0; i < m_keys.size(); ++i)
            {
                cvLine(inputImage, cvPoint(m_keys[i], 0), cvPoint(m_keys[i], 255), color); 
            }
        }
        else
        {
            if (m_data.size() != inputImage->height)
                return;
            for (size_t i = 0; i < m_keys.size(); ++i)
            {
                cvLine(inputImage, cvPoint(0, m_keys[i]), cvPoint(255, m_keys[i]), color); 
            }
        }
    }
}