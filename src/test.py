import argparse

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-t', 
                        type = str)
    

    args = parser.parse_args()

    if args.t:
        print('hi im here theres an arg')
    else:
        print('bye nothing here ')

    