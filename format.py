import os
import subprocess
import sys
import platform

def set_working_directory_to_script_location():
    """Set the working directory to the directory where the script is located."""
    script_dir = os.path.dirname(os.path.abspath(__file__))
    os.chdir(script_dir)
    print(f"Working directory set to: {script_dir}")

def install_clang_format():
    """Install clang-format based on the operating system."""
    system = platform.system()
    try:
        if system == "Darwin":  # macOS
            print("Installing clang-format on macOS using Homebrew...")
            subprocess.run(["brew", "install", "clang-format"], check=True)
        elif system == "Windows":
            print("Installing clang-format on Windows...")
            subprocess.run(
                [
                    "powershell",
                    "-Command",
                    "(New-Object System.Net.WebClient).DownloadFile('https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.0/LLVM-15.0.0-win64.exe', 'LLVM-Installer.exe')"
                ],
                check=True
            )
            subprocess.run(["LLVM-Installer.exe", "/S"], check=True)
        else:
            print(f"Unsupported OS: {system}. Please install clang-format manually.")
            sys.exit(1)
        print("clang-format installed successfully.")
    except subprocess.CalledProcessError as e:
        print(f"Error during installation of clang-format: {e}")
        sys.exit(1)

def check_clang_format():
    """Check if clang-format is installed."""
    try:
        subprocess.run(["clang-format", "--version"], check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        print("clang-format is installed.")
        return True
    except subprocess.CalledProcessError as e:
        print(f"clang-format check failed: {e}")
        return False
    except FileNotFoundError:
        print("clang-format is not installed.")
        return False

def run_clang_format():
    """Run clang-format on specific file types based on the operating system."""
    system = platform.system()
    print("Running clang-format...")
    try:
        if system == "Darwin" or system == "Linux":  # macOS or Linux
            result = subprocess.run(
                "find . -name '*.java' -o -name '*.h' -o -name '*.m' -o -name '*.cpp' | xargs clang-format -i",
                shell=True,
                check=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE
            )
        elif system == "Windows":  # Windows
            for root, dirs, files in os.walk("."):
                for file in files:
                    if file.endswith((".java", ".h", ".m", ".cpp")):
                        filepath = os.path.join(root, file)
                        result = subprocess.run(
                            ["clang-format", "-i", filepath],
                            check=True,
                            stdout=subprocess.PIPE,
                            stderr=subprocess.PIPE
                        )
                        print(result.stdout.decode('utf-8'))
                        print(result.stderr.decode('utf-8'))
        print("clang-format completed successfully.")
    except subprocess.CalledProcessError as e:
        print(f"Error while running clang-format: {e}")
        print(f"stdout: {e.stdout.decode('utf-8')}")
        print(f"stderr: {e.stderr.decode('utf-8')}")
        sys.exit(1)

def run_dart_format():
    """Run dart format on all Dart files."""
    print("Running dart format...")
    try:
        subprocess.run(["dart", "format", "."], check=True)
        print("dart format completed successfully.")
    except subprocess.CalledProcessError as e:
        print(f"Error while running dart format: {e}")
        sys.exit(1)
    except FileNotFoundError:
        print("dart is not installed or not found in PATH.")
        sys.exit(1)

def main():
    """Main function to check and run format commands."""
    set_working_directory_to_script_location()

    if not check_clang_format():
        install_clang_format()
        if not check_clang_format():
            print("Failed to install clang-format. Exiting.")
            sys.exit(1)

    run_clang_format()
    run_dart_format()

if __name__ == "__main__":
    main()
