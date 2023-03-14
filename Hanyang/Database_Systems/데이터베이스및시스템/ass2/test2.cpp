#include <bits/stdc++.h>
#include <algorithm>
using namespace std;

class name_age {
	public:
		string name;
		string age;
		
		void set_name_age(string tuple)
		{
			stringstream tuplestr(tuple);
			//string agestr;

			getline(tuplestr, name, ',');
			getline(tuplestr, age);
		}
};

class name_salary {
	public:
		string name;
		string salary;
		
		void set_name_salary(string tuple)
		{
			stringstream tuplestr(tuple);
			//string salarystr;

			getline(tuplestr, name, ',');
			getline(tuplestr, salary);
		}
};

string make_tuple(string name, string age, string salary)
{
	return name+ ',' + age + ',' + salary + '\n';
}

int main(){

	string buffer[2];
	name_age temp0;
	name_salary temp1;
	fstream block[12];
	ofstream output;
	
	output.open("./output2.csv");

	if(output.fail())
	{
		cout << "output file opening fail.\n";
	}


	/******************************************************************/
	
	for(int i = 0; i < 1000; i++)
	{
		block[0].open("./name_age/" + to_string(i) + ".csv");
		for(int j = 0; j < 10; j++)
		{
			getline(block[0], buffer[0]);
			temp0.set_name_age(buffer[0]);
			for(int l = 0; l < 1000; l+=10)
			{
				for(int a = 0; a < 10; a ++) block[a+1].open("./name_salary/" + to_string(l+a) + ".csv");
				for(int a = 0; a < 10; a ++)
				{
					for(int k = 0; k < 10; k++)
					{
						getline(block[a+1], buffer[1]);
						temp1.set_name_salary(buffer[1]);
						if(temp0.name == temp1.name) 
						{
							output << make_tuple(temp0.name, temp0.age, temp1.salary);
							
						}
					}
					block[a+1].close();
				}
			}
		}
		block[0].close();
	}
	/******************************************************************/

	output.close();

	
}
