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



var thin_rate = 0.1;

var outvars = 0

function fline(line) {

   // console.log(line);
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

    if(Math.random() > thin_rate) return;

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

if(argv.thin) thin_rate = parseFloat(argv.thin)

outfile = argv.out
if(!outfile) outfile = "/tmp/out.vcf"



var header = ''
var H_REF=3,H_ALT=4, H_INFO=7, H_FIELD=8;


var total_var = 0;
var annot_var = 0;

var fdout = fs.openSync(outfile, "w")
var sampleNames;








if(argv.in != undefined)
    str = fs.createReadStream(argv.in + "" , { encoding:'ascii'})
else
    str = process.stdin

//const zlib = require('zlib');
//gunzip = zlib.createGunzip();
//str2 = str.pipe(gunzip)

byLine(str,fline,fend)


