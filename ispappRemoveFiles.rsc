# Find and remove all files with 'ispapp' in the name
:foreach file in=[/file find where name~"ispapp"] do={
    /file remove $file;
}
