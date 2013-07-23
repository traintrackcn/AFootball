
//#import "LoggerClient.h"


#ifdef DEBUG
//    #define LOG_DEBUG(__format,__args...) LogMessageF(__FILE__, __LINE__, __FUNCTION__, @"debug", 0, @"%@",[NSString stringWithFormat:__format, ##__args])

    #define LOG_DEBUG(__format,__args...) NSLog(@"%s:%d %@",__FUNCTION__, __LINE__,[NSString stringWithFormat:__format, ##__args]);
#else
    #define LOG_DEBUG(__format, __args...)  
#endif

#ifdef DEBUG
//    #define LOG_INFO(__format,__args...) LogMessageF(__FILE__, __LINE__, __FUNCTION__, @"info", 0, @"%@",[NSString stringWithFormat:__format, ##__args])
#define LOG_INFO(__format,__args...) NSLog(@"%@",[NSString stringWithFormat:__format, ##__args])
#else
    #define LOG_INFO(__format, __args...)
#endif


#ifdef DEBUG
//    #define LOG_ERROR(__format,__args...) LogMessageF(__FILE__, __LINE__, __FUNCTION__, @"error", 0, @"%@",[NSString stringWithFormat:__format, ##__args])
#define LOG_ERROR(__format,__args...) NSLog(@"%@",[NSString stringWithFormat:__format, ##__args])
#else
    #define LOG_ERROR(__format, __args...)
#endif




#ifdef DEBUG
//    #define LOG_DEBUG(__format,__args...) LogMessageF(__FILE__, __LINE__, __FUNCTION__, @"debug", 0, @"%@",[NSString stringWithFormat:__format, ##__args])

#define TLOG(__format,__args...) NSLog(@"%s:%d %@",__FUNCTION__, __LINE__,[NSString stringWithFormat:__format, ##__args]);
#else
#define TLOG(__format, __args...)
#endif

//#define LOG_TEST(__format,__args...) LogMessageF(__FILE__, __LINE__, __FUNCTION__, @"test", 0, @"%@",[NSString stringWithFormat:__format, ##__args])

#define CCP(__X__,__Y__) CGPointMake(__X__,__Y__)
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define PTM_RATIO 32.0
#define RANDOM_INT arc4random()%999999999

