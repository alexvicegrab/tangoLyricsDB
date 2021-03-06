#! /usr/bin/env python

#
#   Copyright John Quinn, 2009
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

import sys, os, getopt, time, fnmatch
import shutil

def main(argv):
    # set default behavior
    force = False
    ages = 'unset'
    directory = 'unset'
    pattern = '*'

    # process command line
    try:
       opts, args = getopt.getopt(argv, 'ha:d:p:f', ['help', 'ages=', 'directory=', 'pattern=', 'force'])
       if len(args) > 0:
          print 'ignoring args: %s' % args
    except getopt.GetoptError, err:
       print str(err)
       usage()
       sys.exit(2)
    for opt, arg in opts:
       if opt in ('-h', '--help'):
           usage()
           sys.exit(2)
       elif opt in ('-d', '--directory'):
           directory = arg
       elif opt in ('-p', '--pattern'):
           pattern = arg
       elif opt in ('-a', '--ages'):
           ages = arg
       elif opt in ('-f', '--force'):
           force = True

    # verify mandatory arguments
    if ages == 'unset':
       print 'age must be specified (the -a option)'
       usage()

    if directory == 'unset':
       print 'directory must be specified (the -d option)'
       usage()

    # purge the directory
    purge(directory, pattern, ages, force)


# print the usage message and bail
def usage():
    print 'Usage: purgeFiles [OPTION]...';
    print ' -h, --help                          Print this help message';
    print ' -a, --ages=age1,age2                Desired ages to keep (in days)';
    print ' -d, --directory=dir                 Target directory';
    print ' -p, --pattern=pattern               File pattern to match';
    print ' -f, --force                         Force deletion (no simulation mode)\n';
    print 'e.g. purgeFiles --ages=1,2,4,40 --directory=/tmp --pattern="*.txt"';
    print 'This would purge /tmp and try to keep a files ending in .txt of 40 days, 4 days, 2 days and 1 day old. '
    print 'Note: this would only do a simulation run. Specify --force to actually delete the files. '

    print '\nAuthor: John Quinn, http://johnandcailin.com/john';
    sys.exit(2)

# check for backup directory permissions etc
def checkBackupArea(directory):
    areaGood = True

    if os.path.exists(directory) == False:
        print 'filepurge: directory %s: does not exist\n' % directory
        usage()

    if os.path.isdir(directory) == False:
       print 'filepurge: %s is not a directory. please specify the directory to be purged\n' % directory
       usage()

    access = os.access(directory, os.W_OK|os.R_OK)
    if access == False:
        print 'filepurge: directory %s: not readable and writable\n' % directory
        usage()

# check our argument validity
def checkArguments(ages):
    clean, agesList = parseAgesArgument(ages)
    if clean != True:
        print 'filepurge: invalid ages argument: %s' % ages
        usage()
    return agesList


# parse ages argument and return a reverse-chronological list of desired ages in seconds from the epoch
def parseAgesArgument(ages):
    clean = True
    agesList = []
    agesStringList = ages.split(',')
    for ageString in agesStringList:
        if ageString.isdigit() != True:
            clean = False
            break
    for ageString in agesStringList:
        try:
            agesList.append(int(ageString))
        except ValueError:
            clean = False
            break

    agesList.sort(reverse=True)
    return clean, agesList

# return an age sorted directory listing (tuple list), with ages
def getSortedDirList(directory, pattern):
    dirList = os.listdir(directory)
    sortedDirList = []

    for baseName in dirList:
       if fnmatch.fnmatch(baseName, pattern):
           fileName = os.path.join(directory,baseName)
           fileAge = os.path.getmtime(fileName)
           fileTuple = (fileAge, fileName, baseName)
           sortedDirList.append(fileTuple)
    sortedDirList.sort()

    return sortedDirList

# delete the file respecting the force mode
def deleteFile(file, force):
    baseName = file[2]
    fileName = file[1]
    if force == False:
        print '%s: Flagged for deletion' % baseName
    else:
        # First check if we are removing a folder or a file...
        if os.path.isdir(fileName):
            shutil.rmtree(fileName)
            print '%s: Deleted Folder' % baseName
        elif os.path.isfile(fileName):
            os.remove(fileName)
            print '%s: Deleted' % baseName
        else:
            print '%s: is not a file or folder - WARNING!' % baseName


# convert an age in days to seconds from the epoch
def convertAgeToAgeEpoch(age):
    ageEpoch = int(time.time()) - (age * 24*60*60)
    return ageEpoch

# convert an age in seconds from the epoch to days
def convertAgeEpochToAge(ageEpoch):
    age = (int(time.time()) - ageEpoch) / (24*60*60)
    return age

# purge the specified directory
def purge(directory, pattern, ages, force):
    # make sure the backup directory is sound
    checkBackupArea(directory)

    # check arguments are sensible
    agesList = checkArguments(ages)

    # get the listing of the backup directory
    sortedDirList = getSortedDirList(directory, pattern)

    # go through each file in the directory and ensure that it's a keeper
    agesIterator = iter(agesList)
    currentDesiredAge = agesIterator.next()
    completedDesiredAges = False

    print "finding files matching pattern %s of ages %s in directory %s" % (pattern, ages, directory)

    for i,file in enumerate(sortedDirList):
        currentDesiredAgeEpoch = convertAgeToAgeEpoch(currentDesiredAge)
        keeper = False
        fileAge = file[0]
        if i < len(sortedDirList)-1:
            nextFile = sortedDirList[i+1]
            nextFileAge = nextFile[0]

            # should we delete this file?
            if (completedDesiredAges == True) or ((fileAge < currentDesiredAgeEpoch) and (nextFileAge < currentDesiredAgeEpoch)):
                deleteFile(file, force)
            else:
                keeper = True
        else:
            # we're at the last item. if we're still looking, keep it
            if completedDesiredAges == False:
                keeper = True
            else:
                deleteFile(file, force)

        # lovely we found a keeper, so get the next file age to satisfy
        if keeper == True:
            fileAgeDays = convertAgeEpochToAge(fileAge)
            print '%s: keeping this file of age %d days to satisfy age %d days' % (file[2], fileAgeDays, currentDesiredAge)
            try:
                currentDesiredAge = agesIterator.next()
            except StopIteration:
                completedDesiredAges = True

    # if we haven't made our way through all the requested ages, process them anyway, solely to message the user
    if completedDesiredAges == False:
        while True:
            print 'no file to satisfy age %d' % currentDesiredAge
            try:
                currentDesiredAge = agesIterator.next()
            except StopIteration:
                break

if __name__ == '__main__':
    main(sys.argv[1:])
