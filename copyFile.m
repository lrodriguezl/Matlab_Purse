function copyFile(sourcePath,destinationPath)

copyFileCmd = ['cp ', sourcePath,' ',destinationPath];
system(copyFileCmd);

end