import os 
import csv

def generate_report(csv_name,output_name):


    csvpath = os.path.join('raw_data', csv_name )

    #lists to store data
    months = []
    revenue = []
    rev_change = []
    date = []


    with open(csvpath, newline='') as csvfile:

        #csv reader specified delimiter and variable that holds content
        csvreader = csv.reader(csvfile, delimiter=',')
        next(csvreader)

        for row in csvreader:
            #add months
            months.append(row[0])
            revenue.append(row[1])
            

    #count number of months
    num_months = len(months)
    #print(num_months)

    #sum revenue gained
    total_revenue =sum(map(float,revenue))

    #create function to turn into currency format
    def as_currency(value):
        if value >= 0:
            return '${:,.0f}'.format(value)
        else:
            return '(${:,.0f})'.format(value)

    #OTHER CALCULATIONS
    map(float,revenue)
    map(float,rev_change)

    for i in range(1,len(revenue)):
        rev_change.append(float(revenue[i]) - float(revenue[i-1]))
        sum_rev_change = sum(map(float,rev_change))
        avg_rev_change = (float(sum_rev_change)) / len(rev_change)

        max_rev_change = max(rev_change)
        min_rev_change = min(rev_change)

    #TEST MAX AND MIN
    # print(str(max_rev_change) + " ," + str(min_rev_change))

    #FIND DATE OF MAX AND MIN
    max_rev_change_date_index = rev_change.index(max(rev_change))
    # print(max_rev_change_date_index)
    max_rev_change_date = months[max_rev_change_date_index]
    # print(str(max_rev_change_date))

    min_rev_change_date_index = rev_change.index(min(rev_change))
    # print(min_rev_change_date_index)
    min_rev_change_date = months[min_rev_change_date_index]
    # print(str(min_rev_change_date))


    #GREATEST DECREASE IN REVENUE
    print("----------------------------------")
    print("Financial Analysis")
    print("----------------------------------")
    print("Total Months:" + str(num_months))
    print("Total Revenue: " + str(as_currency(total_revenue)))
    print("Average Revenue Change: " + str(as_currency(avg_rev_change)))
    print("Greatest Increase in Revenue: " + max_rev_change_date + " " + str(as_currency(max_rev_change)))
    print("Greatest Decrease in Revenue: " + min_rev_change_date + " " + str(as_currency(min_rev_change)))

    # Specify the file to write to
    output_path = os.path.join('output', output_name)

    # Open the file using "write" mode. 
    f = open(output_path,'w')

    #write to the text file
    f.write("----------------------------------\n")
    f.write("Financial Analysis\n")
    f.write("----------------------------------\n")
    f.write("Total Months: " + str(num_months) + "\n")
    f.write("Total Revenue: " + str(as_currency(total_revenue)) + "\n")
    f.write("Average Revenue Change: " + str(as_currency(avg_rev_change)+ "\n"))
    f.write("Greatest Increase in Revenue: " + max_rev_change_date + " " + str(as_currency(max_rev_change))+ "\n")
    f.write("Greatest Decrease in Revenue: " + min_rev_change_date + " " + str(as_currency(min_rev_change))+ "\n")
    f.close

generate_report('budget_data_1.csv','financial_data_1')
generate_report('budget_data_2.csv','financial_data_2')

