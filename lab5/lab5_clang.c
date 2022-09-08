#include <math.h>
#include <stdio.h>
#include <time.h>

#define STB_IMAGE_IMPLEMENTATION
#define STB_IMAGE_WRITE_IMPLEMENTATION

#include "stb_image.h"
#include "stb_image_write.h"

const char input_jpg[] = "input.jpg";
const char output_jpg_1[] = "output_1.jpg";
const char output_jpg_2[] = "output_2.jpg";

unsigned char *image_rotation_arm64(unsigned char *input_buffer, int input_width, int input_height, double rotation_angle, int output_width, int output_height);

unsigned char *image_rotation_clang(unsigned char *input_buffer, int input_width, int input_height, double rotation_angle, int output_width, int output_height) {
    int size = output_width * output_height * 3;
    unsigned char *result_buffer_clang = (unsigned char *)calloc(size, sizeof(unsigned char));
    
    int half_input_width = input_width / 2;
    int half_input_height = input_height / 2;
    int half_output_width = output_width / 2;
    int half_output_height = output_height / 2;
    
    double cosine_value = cos(rotation_angle);
    double sine_value = sin(rotation_angle);
    
    for (int current_width = 0; current_width < output_width; current_width++) {
        for (int current_height = 0; current_height < output_height; current_height++) {
            int X = (current_width - half_output_width) * cosine_value + (current_height - half_output_height) * sine_value + half_input_width;
            int Y = (half_output_width - current_width) * sine_value + (current_height - half_output_height) * cosine_value + half_input_height;
            
            if (X < input_width && X >= 0 && Y < input_height && Y >= 0) {
                result_buffer_clang[current_width * 3 + current_height * output_width * 3] = input_buffer[X * 3 + Y * input_width * 3];
                result_buffer_clang[current_width * 3 + current_height * output_width * 3 + 1] = input_buffer[X * 3 + Y * input_width * 3 + 1];
                result_buffer_clang[current_width * 3 + current_height * output_width * 3 + 2] = input_buffer[X * 3 + Y * input_width * 3 + 2];
            }
        }
    }
    
    return result_buffer_clang;
}

int main(int argc, char *argv[]) {
    const char *input_data = (argc > 1) ? argv[1] : input_jpg;
    const char *output_data = (argc > 2) ? argv[2] : output_jpg_1;
    
    int input_width, input_height, comp_number, input_rotation_angle;
    unsigned char *input_buffer = stbi_load(input_data, &input_width, &input_height, &comp_number, 0);
    if (!input_buffer) {
        fprintf(stdout, "Error occurred when opening input file!\n");
        return -1;
    }
    
    fprintf(stdout, "Rotation angle: ");
    int ret_code = scanf("%d", &input_rotation_angle);
    if (ret_code != 1) {
        fprintf(stdout, "Invalid rotation angle!\n");
        return -1;
    }
    
    double rotation_angle = (input_rotation_angle / 180.) * M_PI;
    int output_width = input_width * fabs(cos(rotation_angle)) + input_height * fabs(cos(M_PI / 2 - rotation_angle));
    int output_height = input_width * fabs(sin(rotation_angle)) + input_height * fabs(sin(M_PI / 2 - rotation_angle));
    
    struct timespec timer, input_timer, output_timer;
    
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &input_timer);
    unsigned char *result_buffer_clang = image_rotation_clang(input_buffer, input_width, input_height, rotation_angle, output_width, output_height);
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &output_timer);
    timer.tv_sec = output_timer.tv_sec - input_timer.tv_sec;
    if ((timer.tv_nsec = output_timer.tv_nsec - input_timer.tv_nsec) < 0) {
        timer.tv_sec--;
        timer.tv_nsec += 1000000000;
    }
    stbi_write_jpg(output_data, output_width, output_height, comp_number, result_buffer_clang, 100);
    fprintf(stdout, "Rotation time (clang): %ld.%5ld\n", timer.tv_sec, timer.tv_nsec);
    
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &input_timer);
    unsigned char *result_buffer_arm64 = image_rotation_arm64(input_buffer, input_width, input_height, rotation_angle, output_width, output_height);
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &output_timer);
    timer.tv_sec = output_timer.tv_sec - input_timer.tv_sec;
    if ((timer.tv_nsec = output_timer.tv_nsec - input_timer.tv_nsec) < 0) {
        timer.tv_sec--;
        timer.tv_nsec += 1000000000;
    }
    stbi_write_jpg(output_jpg_2, output_width, output_height, comp_number, result_buffer_arm64, 100);
    fprintf(stdout, "Rotation time (ARM64): %ld.%5ld\n", timer.tv_sec, timer.tv_nsec);
    
    stbi_image_free(input_buffer);
    stbi_image_free(result_buffer_clang);
    stbi_image_free(result_buffer_arm64);
    return 0;
}