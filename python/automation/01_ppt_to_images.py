---

# automation/01_ppt_to_images.py — 복붙 (정리 + 옵션화 + 안전장치)

```python
"""
PPT 슬라이드를 이미지(JPG/PNG) 또는 PDF로 변환하는 스크립트 (Windows + PowerPoint 필요)

- PowerPoint COM 자동화 사용
- 출력 포맷:
  - JPG: 17
  - PNG: 18
  - PDF: 32  (PowerPoint 버전에 따라 상수값이 다를 수 있음. 문제 시 PDF는 별도 확인 필요)

주의:
- PowerPoint 설치 필요
- 권장: 관리자 권한 실행
"""

import os
import comtypes.client

# =========================
# 사용자 설정 (여기만 수정)
# =========================
folder_path = r"C:\Users\dnals\Desktop\저장" # 폴더 위치 지정
ppt_filename = "포트폴리오.pptx"        # ppt 파일명
output_dir_name = "포트폴리오"          # 출력 폴더명
export_format = "JPG"                  # "JPG" | "PNG" | "PDF"
visible = False                        # True면 PowerPoint 창이 보임
# =========================


FORMAT_CODE = {
    "JPG": 17,
    "PNG": 18,
    "PDF": 32,  # 환경에 따라 동작이 다를 수 있음(이슈 시 PDF는 별도 점검)
}


def convert_ppt_from_folder(folder_path: str, ppt_filename: str, output_dir_name: str, export_format: str = "JPG", visible: bool = False):
    ppt_path = os.path.join(folder_path, ppt_filename)
    output_dir = os.path.join(folder_path, output_dir_name)

    print(f"[1] PPT 경로: {ppt_path}")
    print(f"[2] 출력 폴더: {output_dir}")
    print(f"[3] Export format: {export_format}")

    if export_format not in FORMAT_CODE:
        raise ValueError(f"export_format은 {list(FORMAT_CODE.keys())} 중 하나여야 합니다.")

    if not os.path.exists(ppt_path):
        print("❌ PPT 파일이 존재하지 않음.")
        return

    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    powerpoint = None
    presentation = None

    try:
        # PowerPoint COM 객체 생성
        powerpoint = comtypes.client.CreateObject("Powerpoint.Application")
        powerpoint.Visible = 1 if visible else 0

        # PPT 열기
        presentation = powerpoint.Presentations.Open(ppt_path, WithWindow=visible)
        slide_count = presentation.Slides.Count
        print(f"[4] 슬라이드 개수: {slide_count}")

        if slide_count == 0:
            print("❌ 슬라이드가 존재하지 않음.")
            return

        # 저장 (17=JPG, 18=PNG, 32=PDF)
        presentation.SaveAs(output_dir, FORMAT_CODE[export_format])
        print("[5] 저장 완료")

        # 결과 출력
        try:
            files = os.listdir(output_dir)
            print(f"[6] 저장 폴더 파일 수: {len(files)}")
            print("   예시(최대 10개):", files[:10])
        except Exception:
            print("[6] 저장 폴더 목록 출력 실패(권한/경로 확인)")

    except Exception as e:
        print(f"❌ 변환 실패: {e}")

    finally:
        # 리소스 정리
        try:
            if presentation is not None:
                presentation.Close()
        except Exception:
            pass

        try:
            if powerpoint is not None:
                powerpoint.Quit()
        except Exception:
            pass


if __name__ == "__main__":
    convert_ppt_from_folder(
        folder_path=folder_path,
        ppt_filename=ppt_filename,
        output_dir_name=output_dir_name,
        export_format=export_format,
        visible=visible,
    )
