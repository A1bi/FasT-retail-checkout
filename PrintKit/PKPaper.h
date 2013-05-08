@interface PKPaper : NSObject
{
    NSString *name;
    NSString *_baseName;
    int width;
    int height;
    int leftMargin;
    int topMargin;
    int rightMargin;
    int bottomMargin;
}

+ (id)documentPapers;
+ (id)photoPapers;
+ (BOOL)willAdjustMarginsForDuplexMode:(id)arg1;
+ (id)genericBorderlessWithName:(id)arg1;
+ (id)genericWithName:(id)arg1;
+ (id)genericPRC32KPaper;
+ (id)genericHagakiPaper;
+ (id)genericA6Paper;
+ (id)generic4x6Paper;
+ (id)generic3_5x5Paper;
+ (id)genericLetterPaper;
+ (id)genericA4Paper;
@property(nonatomic) int bottomMargin; // @synthesize bottomMargin;
@property(nonatomic) int rightMargin; // @synthesize rightMargin;
@property(nonatomic) int topMargin; // @synthesize topMargin;
@property(nonatomic) int leftMargin; // @synthesize leftMargin;
@property(nonatomic) int height; // @synthesize height;
@property(nonatomic) int width; // @synthesize width;
@property(retain, nonatomic) NSString *name; // @synthesize name;
- (unsigned int)hash;
- (BOOL)isEqual:(id)arg1;
- (id)paperWithMarginsAdjustedForDuplexMode:(id)arg1;
@property(readonly, nonatomic) NSString *localizedName; // @dynamic localizedName;
- (id)localizedNameFromDimensions;
@property(readonly, nonatomic) NSString *baseName; // @dynamic baseName;
- (id)nameWithoutSuffixes:(id)arg1;
@property(readonly, nonatomic) BOOL isBorderless;
@property(readonly, nonatomic) float imageableArea; // @dynamic imageableArea;
@property(readonly, nonatomic) struct CGRect imageableAreaRect;
@property(readonly, nonatomic) struct CGSize paperSize;
//- (id)initWithPWGSize:(struct _pwg_size_s *)arg1 localizedName:(id)arg2 codeName:(id)arg3;
- (id)initWithWidth:(int)arg1 Height:(int)arg2 Left:(int)arg3 Top:(int)arg4 Right:(int)arg5 Bottom:(int)arg6 localizedName:(id)arg7 codeName:(id)arg8;

@end

