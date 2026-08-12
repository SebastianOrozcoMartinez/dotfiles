#!/usr/bin/env fish

# Hierarchical Wallpaper Picker with Folder Navigation

# Usage: ./wallpaper_picker.fish [folder_path]

function show_folder_menu
    set current_folder $argv[1]
    set cache $HOME/.cache/walthumbs
    mkdir -p $cache

    ```
    # Get subdirectories and images in current folder
    set subdirs (find $current_folder -maxdepth 1 -type d ! -path $current_folder | sort)
    set images (find $current_folder -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" -o -iname "*.bmp" -o -iname "*.gif" \) | sort)

    # Build menu entries
    set entries ""

    # Add parent directory option (if not at root)
    if test "$current_folder" != "$root_folder"
        set entries "$entries󰉖  .. (Parent Directory)\x00icon\x1f\n"
    end

    # Add subdirectories
    for subdir in $subdirs
        set dirname (basename $subdir)
        set img_count (find $subdir -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" -o -iname "*.bmp" \) | wc -l)
        set entries "$entries󰉋  $dirname ($img_count images)\x00icon\x1f\n"
    end

    # Add separator if we have both folders and images
    if test (count $subdirs) -gt 0 -a (count $images) -gt 0
        set entries "$entries─────────────────────\x00icon\x1f\n"
    end

    # Add images with thumbnails
    set batch_size 20
    set processed 0

    for image in $images
        set basename_img (basename $image)
        set cache_name (string replace -a "/" "_" (string replace $root_folder/ "" $image))
        set thumb "$cache/$cache_name.png"

        # Generate thumbnail if needed
        if not test -f $thumb
            if string match -q "*.gif" $image
                magick "$image[0]" -resize 256x256^ -gravity center -extent 256x256 \
                    \( +clone -fill black -colorize 100% -fill white -draw "roundrectangle 0,0 255,255 20,20" -threshold 50% \) \
                    -alpha off -compose CopyOpacity -composite PNG32:$thumb 2>/dev/null
            else
                magick $image -resize 256x256^ -gravity center -extent 256x256 \
                    \( +clone -fill black -colorize 100% -fill white -draw "roundrectangle 0,0 255,255 20,20" -threshold 50% \) \
                    -alpha off -compose CopyOpacity -composite PNG32:$thumb 2>/dev/null
            end
        end

        if test -f $thumb
            set entries "$entries󰋩  $basename_img\x00icon\x1f$thumb\n"
        else
            set entries "$entries󰋩  $basename_img\x00icon\x1f\n"
        end

        set processed (math $processed + 1)

        if test (math $processed % $batch_size) -eq 0
            sleep 0.1
        end
    end

    # Show rofi menu
    set folder_name (basename $current_folder)

    if test "$current_folder" = "$root_folder"
        set prompt "󰉋 Wallpapers"
    else
        set prompt "󰉋 $folder_name"
    end

    printf $entries | rofi \
        -dmenu \
        -show-icons \
        -theme ~/.config/rofi/themes.rasi \
        -p "$prompt" \
        -no-lazy-grab
    ```

end

function main
    set -g root_folder $HOME/Pictures/Wallpapers

    ```
    if test (count $argv) -gt 0
        set -g root_folder $argv[1]
    end

    if not test -d $root_folder
        echo "Folder $root_folder does not exist"
        exit 1
    end

    set current_folder $root_folder

    while true
        set choice (show_folder_menu $current_folder)

        if test -z "$choice"
            exit 0
        end

        # Parent directory
        if string match -q "󰉖  .. (Parent Directory)" "$choice"
            set current_folder (dirname $current_folder)

            # Enter subdirectory
        else if string match -q "󰉋  *" "$choice"
            set dirname (string replace -r "󰉋  ([^(]+) \(.*" '$1' "$choice" | string trim)
            set current_folder "$current_folder/$dirname"

            # Select image
        else if string match -q "󰋩  *" "$choice"
            set filename (string replace "󰋩  " "" "$choice")
            set full_path "$current_folder/$filename"

            if test -f "$full_path"
                echo "Setting wallpaper: $full_path"
                wal -i "$full_path"
                ~/.config/wal/hooks/postrun.sh
                exit 0
            else
                echo "File not found: $full_path"
            end

            # Separator
        else if string match -q "─────────────────────" "$choice"
            continue

        else
            exit 0
        end
    end
    ```

end

# Increase file descriptor limit

ulimit -n 2048

# Run main function

main $argv
