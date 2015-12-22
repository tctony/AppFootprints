import sys
import datetime
import FootprintMap

fpmapsignature = FootprintMap.footprint_map_signature
fpmap = FootprintMap.footprint_map

def decode_info(info):
    decode_map = { '%%01': ',',
                   '%%02': '_',
                   '%%03': ':', }
    for pair in decode_map.items():
        if len(pair) == 2:
            info = info.replace(pair[0], pair[1])
    return info

def decode_footprint(fpstr):
    fpdata = fpstr.split(':')

    if fpdata[0] != fpmapsignature:
        print 'invalid footprint signature!'
        return

    if len(fpdata) == 1:
        return

    fps = fpdata[1].split('_')
    if len(fps) >= 3:
        start_time = datetime.datetime.fromtimestamp(float(fps[0]))
        print "%s start" % (start_time.strftime('%Y-%m-%d %H:%M:%S %f'), )

        for i in range(1, len(fps)-1):
            td, code, info = fps[i].split(',')

            code = int(code)
            fpt = start_time + datetime.timedelta(seconds=float(td))
            if code < len(fpmap):
                print "%s (%s %s): %s" % (fpt.strftime('%Y-%m-%d %H:%M:%S %f'), fpmap[code][0], fpmap[code][1], fpmap[code][2]),
            else:
                print "%s unknown footprint code: %d" % (fpt.strftime('%Y-%m-%d %H:%M:%S %f'), code),

            if info:
                print decode_info(info)
            else:
                print ''

        end_time = start_time + datetime.timedelta(seconds=float(fps[-1]))
        print "%s end" % (end_time.strftime('%Y-%m-%d %H:%M:%S %f'), )


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print sys.argv[0], "string"
        sys.exit(1)
    else:
        decode_footprint(sys.argv[1])
