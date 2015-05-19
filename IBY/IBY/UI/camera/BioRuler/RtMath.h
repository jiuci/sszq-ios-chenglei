#pragma once

#include "opencv/cv.h"
#include <math.h>
#include <vector>
#define ZEROF 1e-6
#ifndef _PI_
#define _PI_ 3.141592654f
#endif

using std::vector;

namespace rt
{

    inline int clamp(int v, int min, int max)
    {
        if (v < min)
            return min;
        if (v > max)
            return max;
        return v;
    }

    inline int ToInt(float v)
    {
        return (int)(floor(v+0.5f));
    }
    inline int ToInt(double v)
    {
        return (int)(floor(v+0.5));
    }





    class RtMath
    {
    public:
        static inline int           _compare_(
            const float& _x,
            const float& _y)
        {
            if (_x == 0.0f)
            {
                if (_y >= ZEROF)
                    return -1;
                if (_y <= -ZEROF)
                    return 1;
                return 0;
            }
            else if (_y == 0.0f)
            {
                if (_x >= ZEROF)
                    return 1;
                if (_x <= -ZEROF)
                    return -1;
                return 0;
            }
            else
            {
                float d = _x/_y - 1.0f;
                if (d >= ZEROF)
                    return 1;
                if (d <= -ZEROF)
                    return -1;
                return 0;
            }
        }

        static inline bool          _is_zero_(
            const float& _x)
        {
            if (_x >= ZEROF)
                return false;
            if (_x <= -ZEROF)
                return false;
            return true;
        }
    };

    template<typename Real>
    class RtVec2T
    {
    public:
        RtVec2T             () : x(0.0f), y(0.0f)    {}

        RtVec2T             (Real _x, Real _y) : x(_x), y(_y)    {}

        RtVec2T             (const RtVec2T &other)
        {
            x = other.x;
            y = other.y;
        }

        inline Real        Dot                 (const RtVec2T &other) const
        {
            return x * other.x + y * other.y;
        }

        inline Real        Dot                 (Real x1, Real y1) const
        {
            return x * x1 + y * y1;
        }

        inline Real        Cross               (const RtVec2T &other) const
        {
            return x * other.y - y * other.x;
        }

        inline Real        Cross               (Real x1, Real y1) const
        {
            return x * y1 - y * x1;
        }

        inline Real        DistanceTo          (const RtVec2T &other) const
        {
            return sqrt((x-other.x) * (x-other.x) + (y-other.y) * (y-other.y));
        }


        inline Real        DistanceTo          (Real _x, Real _y) const
        {
            return sqrt((x-_x) * (x-_x) + (y-_y) * (y-_y));
        }

        inline Real         DistanceToLine      (const RtVec2T &a, const RtVec2T &b) const
        {
            RtVec2T d1 = (b-a);
            RtVec2T d2(x-a.x, y-a.y);
            Real area = d2.Cross( d1 );
            return fabsf( area ) / d1.Length();
        }

        inline void         Init                (Real _x, Real _y)
        {
            x = _x;
            y = _y;
        }

        inline Real        Length              () const
        {
            return sqrt(x*x + y*y);
        }

        inline void         Normalize           ()
        {
            Real n2 = Length();
            if (RtMath::_is_zero_(n2))
            {
                x = y = 0.0f;
            }
            else
            {
                x /= n2;
                y /= n2;
            }
        }

        inline Real&        operator[]          (int i)
        {
            return i == 0 ? x : y;
        }

        inline Real         operator[]          (int i) const
        {
            return i == 0 ? x : y;
        }

        inline RtVec2T&     operator=           (Real v)
        {
            x = y = v;
            return *this;
        }

        inline RtVec2T&     operator=           (const RtVec2T &other)
        {
            x = other.x;
            y = other.y;
            return *this;
        }

        inline RtVec2T&     operator+=          (const RtVec2T &other)
        {
            x += other.x;
            y += other.y;
            return *this;
        }

        inline RtVec2T&     operator-=          (const RtVec2T &other)
        {
            x -= other.x;
            y -= other.y;
            return *this;
        }

        inline RtVec2T      operator+           (const RtVec2T &other) const
        {
            return RtVec2T(x+other.x, y+other.y);
        }

        inline RtVec2T      operator-           (const RtVec2T &other) const
        {
            return RtVec2T(x-other.x, y-other.y);
        }

        inline RtVec2T&     operator*=          (Real v)
        {
            x *= v;
            y *= v;
            return *this;
        }

        inline RtVec2T&     operator/=          (Real v)
        {
            x /= v;
            y /= v;
            return *this;
        }

        inline RtVec2T      operator*           (Real v) const
        {
            return RtVec2T(x*v, y*v);
        }

        inline RtVec2T      operator/           (Real v) const
        {
            return RtVec2T(x/v, y/v);
        }

        inline bool         operator==          (const RtVec2T &other) const
        {
            return (x == other.x) && (y == other.y);
        }

        inline bool         operator!=          (const RtVec2T &other) const
        {
            return (x != other.x) || (y != other.y);
        }

        inline bool         operator<           (const RtVec2T &other) const
        {
            if (x < other.x)
                return true;
            if (x > other.x)
                return false;
            return y < other.y;
        }

        inline bool         operator>           (const RtVec2T &other) const
        {
            if (x > other.x)
                return true;
            if (x < other.x)
                return false;
            return y > other.y;
        }

        static inline       size_t size         ()
        {
            return SIZE;
        }

    public:
        Real                x;
        Real                y;

    public:
        const static int SIZE = 2;
    };

    typedef RtVec2T<float> RtPoint;

    class RtLine
    {
    public:
        RtLine              ()
        {
        }

        RtLine              (const RtPoint& a, const RtPoint& b)
        {
            A = a;
            B = b;
        }

        RtLine              (float x1, float y1, float x2, float y2)
        {
            A.Init(x1, y1);
            B.Init(x2, y2);
        }

        RtLine              (const RtLine& other)
        {
            A = other.A;
            B = other.B;
        }

        RtLine&             operator=           (const RtLine& other)
        {
            A = other.A;
            B = other.B;
            return (*this);
        }

        void                Init                (const RtPoint& a, const RtPoint& b)
        {
            A = a;
            B = b;
        }

        void                Init                (float x1, float y1, float x2, float y2)
        {
            A.Init(x1, y1);
            B.Init(x2, y2);
        }

        float               Length              () const
        {
            return A.DistanceTo(B);
        }

        bool                Intersect           (const RtLine& other, RtPoint& point) const
        {
            RtPoint d1 = B - A;
            RtPoint d2 = other.B - other.A;

            float d1Xd2 = d1.Cross(d2);
            if ( fabs(d1Xd2) < 1e-3 )
                return false;

            float t = d1.Cross(A-other.A) / d1Xd2;
            point = other.A + d2 * t;
            return true;
        }

        float               IntersectionAngle   (const RtLine& other, float& angle) const
        {
            RtPoint d1 = B - A;
            RtPoint d2 = other.B - other.A;
            float len1 = d1.Length();
            float len2 = d2.Length();
            if ( fabs(len1) < 1e-3 || fabs(len2) < 1e-3 )
                return false;
            float sinA = fabs( d1.Cross(d2) ) / (len1 * len2);
            return asin( sinA ) / _PI_ * 180.0f;
        }

        float               Pitch               () const
        {
            RtPoint d = B - A;
            float length = d.Length();
            if (length < 1e-3)
                return 0;

            float sinA = fabs( d.y / length );
            return asin( sinA ) / _PI_ * 180.0f;
        }

    public:
        RtPoint             A;
        RtPoint             B;
    };

    typedef std::vector< RtVec2T<float> > RtVec2TArray;
}