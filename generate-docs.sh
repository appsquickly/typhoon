reportsDir=build/reports
resourceDir=Resources
set -e # fail script if any commands fail

#Produce API Documentation
echo '--------------------------------------------------------------------------------'
echo "Generating Doxygen documentation"
echo '--------------------------------------------------------------------------------'

doxygen > ${reportsDir}/doxygen_out.txt 2>&1 || true
mkdir -p ${reportsDir}/api/images
ditto ${resourceDir}/navtree.css ${reportsDir}/api
ditto ${resourceDir}/doxygen.png ${reportsDir}/api
ditto ${resourceDir}/images/ ${reportsDir}/api/images/