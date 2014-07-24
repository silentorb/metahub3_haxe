call target.bat

if %TARGET% == nodejs (
REM	copy "%1\output\nodejs\metahub.js" E:\Websites\vineyard\node_modules\vineyard-metahub\metahub3.js
)
if %TARGET% == php (
REM	xcopy "%1\output\php\lib" E:\Websites\vineyard-drupal\sites\all\modules\custom\vineyard\lib\metahub\ /E /Y
)
