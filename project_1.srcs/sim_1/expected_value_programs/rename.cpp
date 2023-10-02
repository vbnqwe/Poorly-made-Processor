#include <iostream>
#include <vector>
#include <fstream>
#include <bitset>

using namespace std;


void write_list_to_file(string filename, vector<int> to_write){
    ofstream os;
    os.open(filename);
    vector<string> bitstring;
    for(int i : to_write){
        bitstring.push_back(std::bitset< 32 >( i ).to_string());
    }
    for(int i = 0; i < bitstring.size() - 1; i++){
        os << bitstring[i];
        os << "\n";
    }
    os << bitstring[bitstring.size() - 1];
    os.close();
}

//function for generation a random list of length n, with max and min, saved to a file
vector<int> generate_list(string filename, int n, int max, int min){
    vector<int> list;
    for(int i = 0; i < n; i++){
        list.push_back(rand() % (max - min) + min);
    }
    write_list_to_file(filename, list);
    return list;
}

int main(int argc, char* argv[]){
    int NUM_INSTRUCTIONS = 40;

    vector<int> dest;
    vector<int> r1;
    vector<int> r2;
    vector<int> starting_data;
    vector<int> cycles_to_write;
    vector<int> if_add;
    vector<int> if_valid;

    //generate lists
    dest = generate_list("dest.txt", NUM_INSTRUCTIONS, 32, 0);
    r1 = generate_list("r1.txt", NUM_INSTRUCTIONS, 32, 0);
    r2 = generate_list("r2.txt", NUM_INSTRUCTIONS, 32, 0);
    starting_data = generate_list("starting_data.txt", NUM_INSTRUCTIONS, INT_MAX, 0);
    cycles_to_write = generate_list("cycles_to_write.txt", NUM_INSTRUCTIONS, 8, 3);
    if_add = generate_list("if_add.txt", NUM_INSTRUCTIONS, 2, 0);
    if_valid = generate_list("if_valid.txt", NUM_INSTRUCTIONS, 2, 0);

    vector<int> reg_file;
    reg_file = starting_data;

    //generate expected committed order
    vector<int> commit_data;
    vector<int> commit_address;
    vector<int> commit_valid;
    for(int i = 0; i < NUM_INSTRUCTIONS; i++){

        commit_address.push_back(dest[i]);
        commit_valid.push_back(if_valid[i]);
        if(commit_valid[i] == 1){
            if(if_add[i] == 1){
                commit_data.push_back(reg_file[r1[i]] + reg_file[r2[i]]);
            } else {
                commit_data.push_back(reg_file[r1[i]] - reg_file[r2[i]]);
            }
            reg_file[commit_address[i]] = commit_data[i];
        }
    }
    write_list_to_file("commit_data.txt", commit_data);
    write_list_to_file("commit_address.txt", commit_address);
    write_list_to_file("commit_valid.txt", commit_valid);
    write_list_to_file("final_reg_file.txt", reg_file);
    

}


