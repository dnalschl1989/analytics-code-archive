# OCR Setup (Windows)

## 1) Python package 설치
!pip install pillow pytesseract opencv-python numpy

## 2) Tesseract 설치
Windows는 Tesseract OCR 프로그램 설치가 필요함.
설치 후 아래 두 방식 중 하나로 연결

A) PATH가 잡혀 있는 경우
별도 설정 없이 pytesseract가 자동으로 찾음

B) PATH가 안 잡힌 경우(권장)
ocr_images_to_text.py에서 아래 라인 활성화
pytesseract.pytesseract.tesseract_cmd = r"C:\Program Files\Tesseract-OCR\tesseract.exe"

# Version Check
import pytesseract
pytesseract.pytesseract.tesseract_cmd = r"C:\Program Files\Tesseract-OCR\tesseract.exe"
print(pytesseract.get_tesseract_version())

## 3) 주요 Error 요인
Tesseract 미설치 / 경로 오타
한글 OCR 언어팩 미설치(언어 데이터 부족)
이미지 해상도 너무 낮음 → 전처리(확대/이진화) 필요
