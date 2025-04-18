import os
from pathlib import Path
import argparse
from datetime import datetime

class FileStructureScanner:
    def __init__(self):
        self.ignore_folders = {'.git', 'node_modules', '__pycache__', 'venv', '.idea'}
        self.ignore_extensions = {'.pyc'}
    
    def scan_directory(self, directory: str, prefix: str = '', level: int = 0) -> str:
        """Scan directory and return formatted string of file structure."""
        result = []
        directory_path = Path(directory)
        
        try:
            # Get all items in directory and sort them (folders first, then files)
            items = sorted(directory_path.iterdir(), 
                         key=lambda x: (not x.is_dir(), x.name.lower()))
            
            for item in items:
                # Skip ignored folders and files
                if item.name in self.ignore_folders or item.suffix in self.ignore_extensions:
                    continue
                
                # Create the display name with proper indentation
                indent = '    ' * level
                if item.is_dir():
                    result.append(f"{indent}📁 {item.name}/")
                    # Recursively scan subdirectories
                    result.append(self.scan_directory(item, prefix, level + 1))
                else:
                    # Add file size if it's a file
                    size = item.stat().st_size
                    size_str = self.format_size(size)
                    result.append(f"{indent}📄 {item.name} ({size_str})")
                    
        except PermissionError:
            result.append(f"{prefix}❌ Permission denied")
        except Exception as e:
            result.append(f"{prefix}❌ Error: {str(e)}")
            
        return '\n'.join(filter(None, result))
    
    @staticmethod
    def format_size(size: int) -> str:
        """Convert size in bytes to human readable format."""
        for unit in ['B', 'KB', 'MB', 'GB']:
            if size < 1024:
                return f"{size:.1f} {unit}"
            size /= 1024
        return f"{size:.1f} TB"
    
    def save_to_file(self, directory: str, output_file: str = None) -> str:
        """Scan directory and save results to a file."""
        if output_file is None:
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            output_file = f"file_structure_{timestamp}.txt"
        
        # Get directory name for the header
        dir_name = Path(directory).absolute()
        
        # Create header with directory info and timestamp
        header = f"""Directory Structure for: {dir_name}
Scanned on: {datetime.now().strftime("%Y-%m-%d %H:%M:%S")}
{'=' * 50}
"""
        
        # Scan directory and get structure
        structure = self.scan_directory(directory)
        
        # Combine header and structure
        full_content = f"{header}\n{structure}"
        
        # Save to file
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(full_content)
            
        return output_file

def main():
    parser = argparse.ArgumentParser(description='Generate a file structure map')
    parser.add_argument('directory', nargs='?', default='.',
                      help='Directory to scan (default: current directory)')
    parser.add_argument('-o', '--output', help='Output file name')
    args = parser.parse_args()
    
    scanner = FileStructureScanner()
    output_file = scanner.save_to_file(args.directory, args.output)
    print(f"File structure has been saved to: {output_file}")

if __name__ == '__main__':
    main()