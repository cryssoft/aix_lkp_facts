#
#  FACT(S):     aix_lkp
#
#  PURPOSE:     This custom fact returns a single, string fact called aix_lkp
#               which is the YYYY/MM/DD HH:MM:SS format date/time stamp of the
#		latest kernel patch (based on the history of the bos.mp64
#		package).  If it can't get the data, it returns the "epoch".
#
#  RETURNS:     (hash)
#
#  AUTHOR:      Chris Petersen, Crystallized Software
#
#  DATE:        February 9, 2021
#
#  NOTES:       Myriad names and acronyms are trademarked or copyrighted by IBM
#               including but not limited to IBM, PowerHA, AIX, RSCT (Reliable,
#               Scalable Cluster Technology), and CAA (Cluster-Aware AIX).  All
#               rights to such names and acronyms belong with their owner.
#
#-------------------------------------------------------------------------------
#
#  LAST MOD:    (never)
#
#  MODIFICATION HISTORY:
#
#	(none)
#
#-------------------------------------------------------------------------------
#
Facter.add(:aix_lkp) do
    #  This only applies to the AIX operating system
    confine :osfamily => 'AIX'

    #  Define a ridiculous "last kernel patch" date/time
    l_aixLKP = '1970/01/01 00:00:00'

    #  Do the work
    setcode do
        #  Run the command to list the history of the bos.mp64 package
        l_lines = Facter::Util::Resolution.exec('/bin/lslpp -hc bos.mp64 2>/dev/null')

        #  Loop over the lines that were returned
        l_lines && l_lines.split("\n").each do |l_oneLine|
            #  Skip comments and blanks
            l_oneLine = l_oneLine.strip()
            next if l_oneLine =~ /^#/ or l_oneLine =~ /^$/

            #  Split regular lines, and stash the relevant fields - last line is what we really want
            l_list   = l_oneLine.split(':')
            l_aixLKP = '20' + l_list[6][6..7] + '/' + l_list[6][0..1] + '/' + l_list[6][3..4] + ' ' + l_list[7][0..1] + ':' + l_list[7][3..4] + ':' + l_list[7][6..7]
        end

        #  Implicitly return the contents of the variable
        l_aixLKP
    end
end

