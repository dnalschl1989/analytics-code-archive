"""
OCR: 폴더 내 이미지들을 텍스트로 추출해 단일 txt 파일로 저장

필수:
- Windows/Mac/Linux 가능 (Tesseract 설치 필요)
- Python packages: pillow, pytesseract, opencv-python, numpy

설치:
pip install pillow pytesseract opencv-python numpy

Windows에서 Tesseract PATH가 안 잡히면:
pytesseract.pytesseract.tesseract_cmd = r"C:\Program Files\Tesseract-OCR\tesseract.exe"
"""

from PIL import Image
import pytesseract
import os
import cv2
import numpy as np

# =========================
# 사용자 설정 (여기만 수정)
# =========================

# [Windows only] Tesseract가 PATH에 없다면 직접 경로 지정
# pytesseract.pytesseract.tesseract_cmd = r"C:\Program Files\Tesseract-OCR\tesseract.exe"

input_folder = r"C:\Users\minu1212\Downloads"                  # OCR할 이미지 폴더
output_file = r"C:\Users\minu1212\Downloads\output_text.txt"   # 결과 텍스트 파일
lang = "kor+eng"                                               # "kor" | "eng" | "kor+eng"

exts = [".png", ".jpg", ".jpeg", ".bmp", ".tiff"]              # 처리할 확장자 목록

# =========================
# OCR 동작부 (수정 불필요)
# =========================

def preprocess_for_ocr(img_bgr):
    """
    OCR 인식률 향상을 위한 기본 전처리:
    - gray
    - resize(확대)
    - denoise
    - adaptive threshold
    """
    gray = cv2.cvtColor(img_bgr, cv2.COLOR_BGR2GRAY)
    gray = cv2.resize(gray, None, fx=1.5, fy=1.5, interpolation=cv2.INTER_LINEAR)
    gray = cv2.fastNlMeansDenoising(gray, h=10)
    gray = cv2.adaptiveThreshold(
        gray, 255,
        cv2.ADAPTIVE_THRESH_GAUSSIAN_C,
        cv2.THRESH_BINARY,
        31, 2
    )
    return gray


def run_ocr(input_folder: str, output_file: str, lang: str, exts: list[str]):
    if not os.path.exists(input_folder):
        print("❌ input_folder가 존재하지 않음:", input_folder)
        return

    texts = []
    files = sorted(os.listdir(input_folder))

    target_files = [f for f in files if any(f.lower().endswith(ext) for ext in exts)]
    if not target_files:
        print("❌ 처리할 이미지가 없음. 확장자/폴더 확인 필요")
        return

    print(f"[1] 대상 이미지 수: {len(target_files)}")
    print(f"[2] 출력 파일: {output_file}")
    print(f"[3] OCR lang: {lang}")

    for file in target_files:
        path = os.path.join(input_folder, file)
        print("처리 중:", file)

        img = cv2.imread(path)
        if img is None:
            texts.append(f"===== {file} =====\n❌ 이미지 로드 실패\n")
            continue

        processed = preprocess_for_ocr(img)
        pil_img = Image.fromarray(processed)

        text = pytesseract.image_to_string(pil_img, lang=lang).strip()
        texts.append(f"===== {file} =====\n{text}\n")

    # 결과 저장
    os.makedirs(os.path.dirname(output_file), exist_ok=True)
    with open(output_file, "w", encoding="utf-8") as f:
        f.write("\n".join(texts))

    print("✅ 완료! 결과 파일:", output_file)


if __name__ == "__main__":
    run_ocr(input_folder=input_folder, output_file=output_file, lang=lang, exts=exts)
