// | ----------- address 32 ----------- |  // 32位地址结构
// | tag 23 | index 5 | word 2 | byte 2 |  // 地址划分：23位标记 | 5位索引 | 2位字选择 | 2位字节选择

localparam ADDR_BITS = 32;  // 地址总位数，32位
localparam WORD_BYTES = 4;  // 每个字包含的字节数，4字节
localparam WORD_BYTES_WIDTH = 2;  // log2(4 (WORD_BYTES))，表示选择字节需要的位数
localparam WORD_BITS = (WORD_BYTES * 8);  // 一个字的总位数，4字节×8位=32位
localparam ELEMENT_WORDS = 4;  // 每个缓存块包含的字数，4个字
localparam ELEMENT_WORDS_WIDTH = 2;  // log2(4 (ELEMENT_WORDS))，表示选择字需要的位数
localparam BLOCK_WIDTH = (ELEMENT_WORDS_WIDTH + WORD_BYTES_WIDTH);  // 4，块内偏移的总位数，字选择位数+字节选择位数
localparam ELEMENT_NUM = 64;  // 缓存块的总数，64个块
localparam WAYS = 2;  // 组相联的路数，2路组相联
localparam ELEMENT_INDEX_WIDTH = 6;  // log2(64)，表示所有缓存块需要的索引位数
localparam SET_INDEX_WIDTH = 5;  // log2(64 / 2 (WAYS))，表示组索引需要的位数
localparam TAG_BITS = (ADDR_BITS - SET_INDEX_WIDTH - BLOCK_WIDTH);  // 32 - 5 - 4 = 23，标记位的位数
