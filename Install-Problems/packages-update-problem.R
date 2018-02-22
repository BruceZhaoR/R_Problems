# Windows 安装问题

# 找出哪些包下载了，但是没有安装成功
new_pkgs <- gsub("(?=_).*", "", list.files(file.path(tempdir(), "downloaded_packages", fsep = "\\")), perl = TRUE)
all_pkgs <- installed.packages()[, 1]
setdiff(new_pkgs, all_pkgs)

# 不需要编译的zip包
install.packages("path /to/*.zip", repos = NULL, type = "win.binary")

# 需要编译的tar.gz包
# 需要安装配置好Rtools https://mirrors.tuna.tsinghua.edu.cn/CRAN/bin/windows/Rtools/
install.packages("path /to/tar.gz", repos = NULL, type = "source")

