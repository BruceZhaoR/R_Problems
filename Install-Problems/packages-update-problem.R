# Windows 安装问题

# 找出哪些包下载了，但是没有安装成功

check_install_failed <- function() {
  new_pkgs_files <- list.files(file.path(tempdir(), "downloaded_packages", fsep = "\\"))
  new_pkgs <- gsub("(?=_).*", "", new_pkgs_files, perl = TRUE)
  all_pkgs <- installed.packages()[, 1]
  to_install <- base::setdiff(new_pkgs, all_pkgs)
  if(length(to_install) == 0) {
    stop("All packages have installed well")
  } else {
    path <- file.path(tempdir(), "downloaded_packages", fsep = "\\")
    cat(paste0("  The packages:",'\n', paste0('    "',to_install,'",',collapse = " \n"),"\n  need to be installed manually.\n","  Please go to '",path,"' unzip manually"))
  }
  # Interactive install packages
  if(interactive()) {
    message("\n  Do you want to install the packages automatically?")
    res <- readline("y/n: ")
    if (res == "y") {
      to_install_files <- file.path(tempdir(),"downloaded_packages",new_pkgs_files[grepl(pattern = paste0(to_install, collapse = "|"),x = new_pkgs_files)], fsep= "\\")
      invisible(lapply(to_install_files, FUN = install.packages, repos = NULL))
    } else {
      message(paste0("Please go to '",path,"' unzip manually"))
    }
  }
}

check_install_failed()


# 不需要编译的zip包
install.packages("path /to/*.zip", repos = NULL, type = "win.binary")

# 需要编译的tar.gz包
# 需要安装配置好Rtools https://mirrors.tuna.tsinghua.edu.cn/CRAN/bin/windows/Rtools/
install.packages("path /to/tar.gz", repos = NULL, type = "source")

