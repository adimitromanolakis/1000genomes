// Creates a tfam file
// Creates a table format variant file
// Arguments: nodejs script.ps 'input_file' 'output_file'




var fs = require('fs');

function byLine(stream, fline, fend) {
    var rest = ''
    stream.on('data', function(chunk) {
        var q = chunk.toString('ascii').split("\n"); var l = q.length;
        q[0] = rest + q[0]; for(var i=0;i<l-1;i++) fline(q[i]); rest = q[l-1];
    });
    stream.on('end',  fend );
}







f1 = []
f2 = []
fpos = []
flen = []
fi = []

pos = 0;
k = 0

var header = ''


var H_REF=3,H_ALT=4, H_INFO=7, H_FIELD=8;


var total_var = 0;
var annot_var = 0;



var filter_total_var = 0;
var filter_annot_var = 0;


var tot_chr = {}
var annot_chr = {}




var fdout = fs.openSync("/tmp/out.vcf","w")
var sampleNames;
var dups = {}


function fline(line) {

    if(line[0] == '#') {

        fs.writeSync(fdout,line + "\n")

        if(line[1] != "#")
        {

            }







            if(sampleNames == undefined)
            {




            }






        return;
    }




    total_var++;

    if(Math.random() > 0.1) return;

    if(total_var % 1000 == 0) console.error("Var:" + total_var);
    var x = line.split("\t");


    //console.log(x[7]);
    AF = x[7].match(/AF=([^;]*)/)
    AF = parseFloat(AF[1]);

    if(AF > 0.1 && x[4].length == 1)
    {
       // console.log(AF);

        fs.writeSync(fdout,line + "\n")
    }

}




function fend(line) {


    console.error("Total " + total_var);

    
}


var argv = require('minimist')(process.argv.slice(2));


if(argv.input != undefined)
    str = fs.createReadStream(argv.input + "", {encoding:'ascii'} )
else
    str = process.stdin

byLine(str,fline,fend)


