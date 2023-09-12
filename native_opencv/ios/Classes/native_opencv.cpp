#include <iostream>

#include <opencv2/core.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/imgcodecs.hpp>

//#include "dcolorlib.hpp"
#define COLORLIB_STATIC_DEFINE
#include "colorlib/colorlib.h"

using namespace std;
using namespace cv;

void rotateMat(Mat &matImage, int rotation)
{
	if (rotation == 90) {
		transpose(matImage, matImage);
		flip(matImage, matImage, 1); //transpose+flip(1)=CW
	} else if (rotation == 270) {
		transpose(matImage, matImage);
		flip(matImage, matImage, 0); //transpose+flip(0)=CCW
	} else if (rotation == 180) {
		flip(matImage, matImage, -1);    //flip(-1)=180
	}
}

extern "C" {
	// Attributes to prevent 'unused' function from being removed and to make it visible
	__attribute__((visibility("default"))) __attribute__((used))
	const char* version() {
		return CV_VERSION;
	}

	__attribute__((visibility("default"))) __attribute__((used))
	void initDetector(uint8_t* markerPngBytes, int inBytesCount, int bits) {
//		if (detector != nullptr) {
//			delete detector;
//			detector = nullptr;
//		}

//
//		detector = new ArucoDetector(marker, bits);
	}

	__attribute__((visibility("default"))) __attribute__((used))
	void destroyDetector() {
//		if (detector != nullptr) {
//			delete detector;
//			detector = nullptr;
//		}
	}

	__attribute__((visibility("default"))) __attribute__((used))
	const float* detect(int width, int height, int rotation, uint8_t* bytes, bool isYUV, int32_t* outCount) {
		// if (detector == nullptr) {
		float* empty = new float[1];
		empty[0] = 0;
		// 	return empty;
		// }

		Mat frame;
		if (isYUV) {
			Mat myyuv(height + height / 2, width, CV_8UC1, bytes);
			cvtColor(myyuv, frame, COLOR_YUV2BGRA_NV21);
		} else {
			frame = Mat(height, width, CV_8UC4, bytes);
		}
        // cv::imwrite("/sdcard/DCIM/Camera/output.png", frame);

        cv::Mat image;
		cvtColor(frame, image, COLOR_BGRA2RGB);
		CLR_ColorImage img = { image.cols, image.rows, int(image.step1()), image.data, image.channels(), 0 };
		CLR_ColorImage card = { image.cols, image.rows, int(image.step1()), image.data, image.channels(), 0 };
		int qr;
		CLR_ResultCode rc = CLR_GetCard(&img, &card, &qr);

//        cv::Mat tmp = cv::Mat(card.height, card.width, CV_8UC3, card.pixels, card.stride);
//        test_draw_debug(tmp);
//        cv::imwrite("/sdcard/DCIM/Camera/output_2.png", tmp);

		if (rc != CLR_OK) {
            *outCount = 1;
            return empty;
        }

		CLR_RGB result[11];
    	size_t rlen = 1;
		rc = CLR_ExtractColors(&card, result, &rlen);
		if (rc != CLR_OK) {
            *outCount = 1;
            return empty;
        }


		vector<float> output;
		for (int i = 0; i < rlen; i++) {
			output.push_back(result[i].r);
			output.push_back(result[i].g);
			output.push_back(result[i].b);
		}

		unsigned int total = sizeof(float) * output.size();
		float* jres = (float*)malloc(total);
		memcpy(jres, output.data(), total);

		*outCount = output.size();
		return jres;
	}
}
