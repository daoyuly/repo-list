#!/bin/bash

# 定义一个数组存储找到的 .git 目录路径
found_git_dirs=()

# 递归遍历目录
traverse_directory() {
    local dir="$1"

    # 检查当前目录下是否有 .git 目录
    if [ -d "$dir/.git" ]; then
        found_git_dirs+=("$dir")  # 存入数组
        return  # 终止当前目录的递归
    fi

    # 遍历子目录
    for subdir in "$dir"/*; do
        if [ -d "$subdir" ]; then
            traverse_directory "$subdir"
        fi
    done
}

# 指定要遍历的根目录
root_dir=/Users/umu/Documents/code-repo  # 默认为当前目录
repo_list_dir=/Users/umu/Documents/code-repo/repo-list/readme.md  # 默认为当前目录


# 开始遍历
traverse_directory "$root_dir"

# 遍历找到的 Git 目录并获取远程仓库 URL
echo "Git repositories and their remote URLs:"
for repo in "${found_git_dirs[@]}"; do
    cd "$repo" || continue  # 进入 Git 仓库目录
    remote_url=$(git remote get-url origin 2>/dev/null)  # 获取远程 URL
    echo "- **$repo**"
    if [ -n "$remote_url" ]; then
        echo "- [$remote_url]($remote_url)"
    else
        echo "Remote URL: Not found"
    fi
    echo "---"
    
    # 返回 root_dir
    cd "$root_dir" || exit
done
