#include <a_samp>
#include <foreach>
main() {
    static big[2048];
    foreach(new i : Player) {
        GetPlayerPos(i, 0.0, 0.0, 0.0);
    }
    SetTimer("Lag", 50, true);
}
