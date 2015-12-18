import os
import re
import md5
from datetime import datetime

print 'Getting all source list'
path = os.environ.get('SRCROOT')
sources = []
for (root, dirnames, filenames) in os.walk(path):
    for fn in filenames:
        if fn.endswith('.m') or fn.endswith('.mm'):
            sources.append(root+'/'+fn)
print '  got %d' % len(sources)

print 'Extracting footprint'
actions = []
signature = md5.new()
pattern = re.compile('HLogFootprint\(@\"(.*?)\",')
for s in sources:
    with open(s) as fp:
        ln = 0
        for line in fp:
            ln += 1
            match = pattern.search(line)
            if match:
                oneAction = (os.path.relpath(s, path), ln, match.groups()[0])
                actions.append(oneAction)
                signature.update('(%s_%s)' % (oneAction[0], oneAction[1]))
print '  got %d' % len(actions)
signature = signature.hexdigest()
print '  signature:', signature

print 'Generating objc code'
fp_h = open(os.path.dirname(os.path.realpath(__file__))+'/FootprintMap.h', 'w');
fp_h.write('// code generated by GenFootprintMap.py\n')
fp_h.write('// '+datetime.now().strftime("%Y-%m-%d %H:%M:%S")+'\n')
fp_h.write('// !!! DO NOT MODIFIY !!!\n')
fp_h.write('#import <Foundation/Foundation.h>\n')
fp_h.write('#define FootprintMapSignature @"%s"\n' % (signature, ))
fp_h.write('@interface FootprintMap : NSObject\n')
fp_h.write('+ (NSString *)footprintCodeForLine:(NSUInteger)line inFile:(NSString *)file;\n')
fp_h.write('@end\n')
fp_h.close();

fp_m = open(os.path.dirname(os.path.realpath(__file__))+'/FootprintMap.m', 'w')
fp_m.write('// code generated by GenFootprintMap.py\n')
fp_m.write('// '+datetime.now().strftime("%Y-%m-%d %H:%M:%S")+'\n')
fp_m.write('// !!! DO NOT MODIFIY !!!\n')
fp_m.write('#import "FootprintMap.h"\n')
fp_m.write('static NSString *srcroot = @"%s";\n' % path)
fp_m.write('static NSDictionary *footprint_map = nil;\n')
fp_m.write('@implementation FootprintMap\n')
fp_m.write('+ (void)initialize\n')
fp_m.write('{\n')
fp_m.write('    footprint_map = @{\n')
for i in range(len(actions)):
    fp_m.write('        @"%s_%d" : @"%d", // %s\n' % ( actions[i][0], actions[i][1], i, actions[i][2]) )
fp_m.write('    };\n')
fp_m.write('}\n')
fp_m.write('''\
+ (NSString *)footprintCodeForLine:(NSUInteger)line inFile:(NSString *)file
{
    if ([file hasPrefix:srcroot]) {
        file = [file stringByReplacingCharactersInRange:NSMakeRange(0, [srcroot length]+1)
                                             withString:@""];
    }
    NSString *key = [NSString stringWithFormat:@"%@_%ld", file, (long)line];
    NSString *code = [footprint_map objectForKey:key];
    return code ?: key;
}
''');
fp_m.write('@end\n')
fp_m.close();

print 'Generating python code'
fp_py = open(os.path.dirname(os.path.realpath(__file__))+'/FootprintMap.py', 'w');
fp_py.write('# code generated by GenFootprintMap.py\n')
fp_py.write('# '+datetime.now().strftime("%Y-%m-%d %H:%M:%S")+'\n')
fp_py.write('# !!! DO NOT MODIFIY !!!\n')
fp_py.write('footprint_map_signature = \'%s\'\n' % (signature, ))
fp_py.write('footprint_map = [\n')
for a in actions:
    fp_py.write('    '+repr(a)+',\n')
fp_py.write(']')
fp_py.close();

print 'Done'
