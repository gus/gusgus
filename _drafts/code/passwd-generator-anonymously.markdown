    while :
    > do
    > ./pwGen -l 9
    > sleep 1
    > done

    Required Arguments (1): passed... Password: #F@jU7y1q
    Required Arguments (1): passed... Password: 5t6yi#XJ=
    Required Arguments (1): passed... Password: 0Au6g@Io#
    Required Arguments (1): passed... Password: 2x@hD5Aw^
    Required Arguments (1): passed... Password: @=b2At6iW
    Required Arguments (1): passed... Password: Ps=4#6Czw
    Required Arguments (1): passed... Password: j@T45e#aD
    Required Arguments (1): passed... Password: 1eM2y#o^U
    Required Arguments (1): passed... Password: =@j6gbQ3G
    Required Arguments (1): passed... Password: ^Pxfq4J7#
    Required Arguments (1): passed... Password: ^d4Z1k#Aq
    Required Arguments (1): passed... Password: g@dE8#Vz6
    Required Arguments (1): passed... Password: SQi0^b7@u
    Required Arguments (1): passed... Password: @BoijD7^8
    Required Arguments (1): passed... Password: s5eq#F@Y2
    Required Arguments (1): passed... Password: whSKi=12@
    Required Arguments (1): passed... Password: n7^=IqeS4
    Required Arguments (1): passed... Password: 2f#^hB0Au
    Required Arguments (1): passed... Password: 23aWE@=nk

Here are the seeds:

    seed1 = ['a','b','c','d','e','f','g','h','i','j', 'k','m','n','o','p','q','r','s','t','u', 'v','w','x','y','z']
    seed2 = ['1','2','3','4','5','6','7','8','9','0']
    seed3 = ['A','B','C','D','E','F','G','H','I','J', 'K','L','M','N','P','Q','R','S','T','U', 'V','W','X', 'Y','Z']
    seed4 = ['@','=','#','^']
    maxLength = 25
    upperCase = 2
    special = 2
    numbers = 2

Each seed is randomized and then used to craft the final password after one more final randomization. The script is totally dynamic and configurable for even the most strict password testing PAM modules in use today. In the case above with the options given, the min length is 6 because you are forcing 2 upper, 2 numeral, and 2 special characters into the password. The additional characters are random "fill" in order to meet the specified length asked for. There is only one routine that tries to be crafty (unlike almost every line in your script) which looks for a repeated character. If a repeated character is found it will be replaced with another random character until the condition is met. While this is not truly needed, some password checking systems require all characters to be unique. - Anonymous

    13 character passwords
    > ./pwGen -l 13
    > sleep 1
    > done
    Required Arguments (1): passed... Password: gib#rw5Hk0^vD
    Required Arguments (1): passed... Password: iuL1kS@8o#szr
    Required Arguments (1): passed... Password: eTo@1=Xyizhr4
    Required Arguments (1): passed... Password: zh0t#jG5mRgr=
    Required Arguments (1): passed... Password: ijV6a^@7dwpPq
    Required Arguments (1): passed... Password: Nsq@43^jaDyfk
    Required Arguments (1): passed... Password: u5^e3Z#irdtfB
    Required Arguments (1): passed... Password: nheE71kLtb#w^
    Required Arguments (1): passed... Password: cru4o#Pte^H7v
    Required Arguments (1): passed... Password: q1vu=^x2YNomk
    Required Arguments (1): passed... Password: ur3i=#eCda9oV
    Required Arguments (1): passed... Password: bhfse2UdX0@=n
    Required Arguments (1): passed... Password: 4kM@#zw6Wfiec
    Required Arguments (1): passed... Password: b@ve60nXY=kxz
    Required Arguments (1): passed... Password: m7kXo^#a5rgzR
