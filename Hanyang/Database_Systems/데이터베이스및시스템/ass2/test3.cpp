#include <bits/stdc++.h>
using namespace std;

class name_grade {
	public:
		string student_name;
		int korean;
		int math;
		int english;
		int science;
		int social;
		int history;

		void set_grade(string tuple)
		{
			stringstream tuplestr(tuple);
			string tempstr;

			getline(tuplestr, student_name, ',');

			getline(tuplestr, tempstr, ',');
			korean = stoi(tempstr);
			
			getline(tuplestr, tempstr, ',');
			math = stoi(tempstr);
			
			getline(tuplestr, tempstr, ',');
			english = stoi(tempstr);
			
			getline(tuplestr, tempstr, ',');
			science = stoi(tempstr);
			
			getline(tuplestr, tempstr, ',');
			social = stoi(tempstr);
			
			getline(tuplestr, tempstr);
			history = stoi(tempstr);
		}
};

class name_number{
	public :
		string student_name;
		string student_number;

		void set_number(string tuple)
		{
			stringstream tuplestr(tuple);
			string tempstr;


			getline(tuplestr, student_name, ',');
			getline(tuplestr, student_number, ',');
		}
};

string make_tuple(string name, string number)
{
	string ret = "";

	ret += name+ "," + number +"\n";

	return ret;
}

int hashFunction(int f_korea, int f_math, int f_english, int f_science, int f_social, int f_history,
						int s_korea, int s_math, int s_english, int s_science, int s_social, int s_history)
{
	int gradeChangeNum = 0;
	if(f_korea > s_korea) gradeChangeNum += 1;
	if(f_math > s_math) gradeChangeNum += 1;
	if(f_english > s_english) gradeChangeNum += 1;
	if(f_science > s_science) gradeChangeNum += 1;
	if(f_social > s_social) gradeChangeNum += 1;
	if(f_history > s_history) gradeChangeNum += 1;
	return gradeChangeNum;
}

int main(){

	string buffer[2];
	name_grade temp0;
	name_grade temp1;
	name_number temp2;
	fstream block[12];
	ofstream output;

	output.open("./output3.csv");
	if(output.fail())
	{
		cout << "output file opening fail.\n";
	}

	/*********************************************************************/
	// make hash table in buckets
	block[11].open("../buckets/hashtable.csv");
	if(block[11].fail())
	{
		cout << "output file opening fail.\n";
	}
	
	for(int i = 0; i < 1000; i++)
	{
		block[0].open("./name_grade1/" + to_string(i) + ".csv");
		for(int j = 0; j < 10; j++)
		{
			getline(block[0], buffer[0]);
			temp0.set_grade(buffer[0]);
			for(int l = 0; l < 1000; l+=10)
			{
				for(int a = 0; a < 10; a ++) block[a+1].open("./name_grade2/" + to_string(l+a) + ".csv");
				for(int a = 0; a < 10; a ++)
				{
					for(int k = 0; k < 10; k++)
					{
						getline(block[a+1], buffer[1]);
						temp1.set_grade(buffer[1]);
						if(temp0.student_name == temp1.student_name)
						{
							if(hashFunction(temp0.korean, temp0.math, temp0.english, temp0.science, temp0.social, temp0.history,
											temp1.korean, temp1.math, temp1.english, temp1.science, temp1.social, temp1.history) >= 2) block[11] << temp1.student_name + '\n';
						}
					}
					block[a+1].close();
				}
			}
		}
		block[0].close();
	}
	block[11].close();
	
	//result output

	for(int i = 0; i < 1000; i++)
	{
		block[0].open("./name_number/" + to_string(i) + ".csv");
		for(int j = 0; j < 10; j++)
		{
			getline(block[0], buffer[0]);
			temp2.set_number(buffer[0]);
			block[1].open("../buckets/hashtable.csv");
			if(block[1].fail()) cout << "open hashtable.csv fail \n";
			while(!block[1].eof())
			{
				getline(block[1],buffer[1]);
				if(buffer[1] == temp2.student_name)
				{
					output << make_tuple(temp2.student_name, temp2.student_number);
					break;
				}
			}
			block[1].close();
		}
		block[0].close();
	}
	
	/*********************************************************************/

	output.close();
}
