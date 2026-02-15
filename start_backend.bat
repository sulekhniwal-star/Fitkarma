@echo off
echo Starting FitKarma PocketBase Backend...
cd backend
pocketbase.exe serve --http="127.0.0.1:8090"
pause
