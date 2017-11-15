#!/bin/bash
# Builds ebook from markdown
# also see: https://puppet.com/blog/how-we-automated-our-ebook-builds-pandoc-and-kindlegen
# and https://www.eenmanierom.nl/e-book-in-pdf-epub-en-mobi-maken-met-markdown-en-pandoc/#Pandoc-commando8217s

echo Pulling docker container for pandoc
# see: https://hub.docker.com/r/vbatts/pandoc/
docker pull vbatts/pandoc

echo Cleaning output directory
rm -rf ./output

# sudo docker run -it --rm vbatts/pandoc --list-highlight-languages

echo
echo Running pandoc container
sudo docker run -it \
        --rm \
        -v $(pwd)/:/input/:ro \
        -v $(pwd)/output/:/output/ \
        vbatts/pandoc -f markdown_github --toc \
        -o /output/gbb-container-lab-attendee-guide.pdf /input/step-by-step.md
