import os
import re
import shutil

def convert_to_screenutil(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        content = file.read()

    original_content = content

    # Match patterns like height: 120, width: 50, SizedBox(height: 20)
    patterns = [
        (r'height:\s*([0-9]+(?:\.[0-9]+)?)', r'height: \1.h'),
        (r'width:\s*([0-9]+(?:\.[0-9]+)?)', r'width: \1.w'),
        (r'SizedBox\s*\(\s*height:\s*([0-9]+(?:\.[0-9]+)?)', r'SizedBox(height: \1.h'),
        (r'SizedBox\s*\(\s*width:\s*([0-9]+(?:\.[0-9]+)?)', r'SizedBox(width: \1.w'),
        (r'EdgeInsets\.all\((\d+(?:\.\d+)?)\)', r'EdgeInsets.all(\1.w)'),
        (r'EdgeInsets\.symmetric\((.*?)horizontal:\s*(\d+(?:\.\d+)?)(.*?)\)', r'EdgeInsets.symmetric\1horizontal: \2.w\3'),
        (r'EdgeInsets\.symmetric\((.*?)vertical:\s*(\d+(?:\.\d+)?)(.*?)\)', r'EdgeInsets.symmetric\1vertical: \2.h\3'),
        (r'EdgeInsets\.only\((.*?)left:\s*(\d+(?:\.\d+)?)(.*?)\)', r'EdgeInsets.only\1left: \2.w\3'),
        (r'EdgeInsets\.only\((.*?)right:\s*(\d+(?:\.\d+)?)(.*?)\)', r'EdgeInsets.only\1right: \2.w\3'),
        (r'EdgeInsets\.only\((.*?)top:\s*(\d+(?:\.\d+)?)(.*?)\)', r'EdgeInsets.only\1top: \2.h\3'),
        (r'EdgeInsets\.only\((.*?)bottom:\s*(\d+(?:\.\d+)?)(.*?)\)', r'EdgeInsets.only\1bottom: \2.h\3'),
    ]

    for pattern, replacement in patterns:
        content = re.sub(pattern, replacement, content)

    # If file changed, make a backup and rewrite
    if content != original_content:
        backup_path = file_path + '.bak'
        shutil.copy(file_path, backup_path)
        with open(file_path, 'w', encoding='utf-8') as file:
            file.write(content)
        print(f"✅ Updated: {file_path}")
    else:
        print(f"— No change: {file_path}")

def scan_directory(directory):
    for root, _, files in os.walk(directory):
        for name in files:
            if name.endswith('.dart'):
                convert_to_screenutil(os.path.join(root, name))

# Run script
if __name__ == "__main__":
    project_path = input("Enter your Flutter project path: ").strip()
    scan_directory(project_path)
    print("\n✅ Conversion complete! (Backups created with .bak extension)")
