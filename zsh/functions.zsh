# Utility functions

# Generate .gitignore from toptal.com
function gi() {
    curl -sLw "\n" https://www.toptal.com/developers/gitignore/api/$@ ;
}
